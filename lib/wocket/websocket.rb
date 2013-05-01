require 'websocket'
require 'celluloid'
require 'pry'

module Wocket
  class WebSocket
    include Celluloid

    class HandshakeError < RuntimeError; end

    attr_reader :version, :state

    BUFFER_SIZE = 4096

    STATUS_CODES = {
      normal_closure:       1000,
      going_away:           1001,
      protocol_error:       1002,
      invalid_data:         1003,
      inconsistent_data:    1007,
      policy_violation:     1008,
      too_large:            1009,
      extension_error:      1010,
      unexpected_condition: 1011
    }

    # Initializes a new Wocket WebSocket, verifies the client handshake, if
    #   the handhake is valid the server returns a handshake completing the
    #   handshake process.
    # @param socket [TCPSocket] TCPSocket of the new connection
    # @param server [Wocket::Server] The instance of the Wocket server that
    #   that the websocket belongs to
    def initialize(socket, server)
      @socket    = socket
      @server    = server
      @state     = :connecting
      @stop_read = false

      validate_handshake
    end

    # Returns true if the client is connected, false if they are not.
    def connected?
      @state == :connected
    end

    # Writes data frame to the websocket.
    # @param data [String] String of data to be pushed to the client.
    # @param type [Symbol] The type of data to send to the client. Must be :text
    #   or :binary
    def push(data = '', type = :text)
      frame = outgoing_frame.new(version: @version, data: data, type: type)
      @socket.write frame.to_s
    end
    alias_method :write, :push


    # Closes the open websocket with a code and a reason defaulting to a normal
    #   closure, once connection is closed the :onclose callback is triggered.
    # @param code [Integer] Disconnect status code.
    #   See http://tools.ietf.org/html/rfc6455#section-7.4.1
    # @param reason [String] An explanation why the connection is being closed.
    def close(code = :normal_closure, reason = "normal closure")
      code = STATUS_CODES[code]
      @stop_read = true

      unless @socket.closed?
        @socket.write outgoing_frame.new(version: @version,
                                         data:    reason,
                                         type:    :close,
                                         code:    code).to_s

        @socket.close
      end

      @state = :disconnected
      @server.trigger(:onclose, self, code, reason)
    end

    # Send a ping message to the client
    def ping

    end

   private

    def validate_handshake
      handshake = ::WebSocket::Handshake::Server.new
      handshake << readpartial until handshake.finished?

      @version = handshake.version

      if handshake.valid?
        @socket.write handshake.to_s
        @state = :connected
        @server.trigger(:onopen, self)

        @socket.wait_readable
        async.read
      else
        @state = :invalid_handshake
        @socket.write "HTTP/1.1 400 Bad Request"
        @socket.close

        raise HandshakeError, "Invalid handshake received, connection closed."
      end
    end

    def read
      loop do
        break if @stop_read


        incoming_frame << readpartial until msg = incoming_frame.next || incoming_frame.error

        if incoming_frame.error
          handle_invalid_frame(incoming_frame)

          @incoming_frame = nil
        elsif msg
          case msg.type
          when :text
            handle_text_message(msg)
          when :binary
            handle_binary_message(msg)
          when :ping
            handle_ping(msg)
          when :close
            handle_close(msg)
          else
            # Do nothing for now
          end
        end
      end
    rescue EOFError, Errno::ECONNRESET, IOError, Errno::EPIPE
      puts "Socket Gone, where did it go?"
      # close
    end

    def handle_text_message(msg)
      case msg.data.size
      when 0, *(125..128).to_a, *(65535..65536).to_a
        push msg.data
      else
        @server.trigger(:onmessage, self, msg.data, msg.type)
      end
    end

    def handle_binary_message(msg)
      case msg.data.size
      when 0, *(125..128).to_a, *(65535..65536).to_a
        push msg.data, :binary
      else
        @server.trigger(:onmessage, self, msg.data, msg.type)
      end
    end

    def handle_ping(msg)
      if msg.data.length > 125
        # For some reason websockets-ruby isn't passing on PINGS that are too large
        close :protocol_error, "ping message too large"
      else
        frame = outgoing_frame.new(version: @version, type: :pong, data: msg.data)
        @socket << frame.to_s
      end
    end

    def handle_close(msg)
      close
    end

    def handle_invalid_frame(invalid_frame)
      case incoming_frame.error
      when :control_frame_payload_too_long
        close :protocol_error, "protocol error: control frame too long"
      when :reserved_bit_used
        close :protocol_error, "protocol error: reserved bit used"
      when :unknown_opcode
        close :protocol_error, "protocol error: unknown opcode"
      when :fragmented_control_frame
        close :protocol_error, "protocol error: fragmented control frame"
      when :unexpected_continuation_frame
        close :protocol_error, "protocol error: unexpected continuation frame"
      when :data_frame_instead_continuation
        close :protocol_error, "protocol error: data frame instead continuation"
      when :invalid_payload_encoding
        close :inconsistent_data, "inconsistent data error: invalid payload encoding"
      else
        puts incoming_frame.error
      end
    end

    def readpartial
      @socket.readpartial(BUFFER_SIZE)
    end

    def incoming_frame
      @incoming_frame ||= ::WebSocket::Frame::Incoming::Server.new(version: @version)
    end

    def outgoing_frame
      ::WebSocket::Frame::Outgoing::Server
    end
  end
end

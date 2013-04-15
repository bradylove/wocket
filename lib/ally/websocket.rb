require 'websocket'
require 'celluloid'
require 'pry'

module Ally
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

    # Initializes a new Ally WebSocket, verifies the client handshake, if
    #   the handhake is valid the server returns a handshake completing the
    #   handshake process.
    # @param socket [TCPSocket] TCPSocket of the new connection
    # @param server [Ally::Server] The instance of the Ally server that
    #   that the websocket belongs to
    def initialize(socket, server)
      @socket    = socket
      @server    = server
      @state     = :connecting

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
    def push(data, type = :text)
      puts data
      frame = outgoing_frame.new(version: @version, data: data, type: type)
      @socket << frame.to_s
    end
    alias_method :write, :push


    # Closes the open websocket with a code and a reason defaulting to a normal
    #   closure, once connection is closed the :onclose callback is triggered.
    # @param code [Integer] Disconnect status code.
    #   See http://tools.ietf.org/html/rfc6455#section-7.4.1
    # @param reason [String] An explanation why the connection is being closed.
    def close(code = STATUS_CODES[:normal_closure], reason = "Normal closure")
      cancel_timer!

      unless @socket.closed?
        @socket.close
      end

      @state = :disconnected
      @server.trigger(:onclose, self, code, reason)
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
        start_timer!
      else
        @state = :invalid_handshake
        @socket.write "HTTP/1.1 400 Bad Request"
        @socket.close

        raise HandshakeError, "Invalid handshake received, connection closed."
      end
    end

    def read
      loop do
        incoming_frame << readpartial until msg = incoming_frame.next

        @server.trigger(:onmessage, self, msg.data, msg.type)
      end
    rescue EOFError, Errno::ECONNRESET
      close
    end

    def start_timer!
      cancel_timer!
      @timer = every(1) { read }
    end

    def cancel_timer!
      @timer && @timer.cancel
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

require 'celluloid/io'

module Ally
  class Server
    include Bindable
    include Celluloid::IO

    DEFAULT_HOST = "127.0.0.1"
    DEFAULT_PORT = 9292

    finalizer :finalize

    def initialize(options = {})
      @options = options
      @host    = options[:host] || DEFAULT_HOST
      @port    = options[:port] || DEFAULT_PORT

      @callbacks = {}
    end

    def available_bindings
      [:onopen, :onclose, :onerror, :onmessage, :onping, :onpong]
    end

    def start
      @server = TCPServer.new(@host, @port)
      async.run
      puts startup_message
    end

    def run
      loop { async.handle_connection @server.accept }
    end

  private

    def startup_message
      msg = "Ally server now listening on port #{@port}\n"
      msg += "-" * 45
      msg
    end

    def finalize
      @server.close if @server
    end

    def handle_connection(socket)
      websocket = WebSocket.new(socket, self)
    end
  end
end

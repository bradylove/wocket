require 'celluloid/io'
require 'celluloid/autostart'
require 'websocket'
require 'uri'
require 'securerandom'
require 'pry'

class WSClient
  include Celluloid
  include Celluloid::IO

  def initialize(uri, id)
    puts "Connection ##{id}"

    @version = 'unknown'
    @id     = id
    @uri    = URI(uri)
    @socket = TCPSocket.new(@uri.host, @uri.port)

    send_handshake
  end

  def send_handshake
    @handshake = WebSocket::Handshake::Client.new(url: @uri.to_s)
    @socket << @handshake.to_s

    @handshake << @socket.readpartial(4096) until @handshake.finished?

    if @handshake.valid?
      @version = @handshake.version
      puts "Valid Handshake ##{@id}"
      async.start_timer
    end
  end

  def read
    frame = WebSocket::Frame::Incoming::Client.new(version: @version)
    frame << @socket.readpartial(4096) until msg = frame.next


    puts "Received: #{msg.data}"
  end

  def start_timer
    cancel_timer!
    @timer = every(3) { send_random_data }
  end

  def cancel_timer!
    @timer && @timer.cancel
  end

  def send_random_data
    @socket << WebSocket::Frame::Outgoing::Client.new(version: @version, data: "Hello world! How are you doing today?", type: :text).to_s
    puts "Sent frame"

    read
  end
end

ARGV[0].to_i.times do |i|
  WSClient.supervise("ws://localhost:9292", i)
  sleep(0.1)
end

sleep

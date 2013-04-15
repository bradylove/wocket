class DummySocket
  def readpartial(int)
    WebSocket::Handshake::Client.new(:url => 'ws://example.com').to_s
  end

  def write(body)

  end
end

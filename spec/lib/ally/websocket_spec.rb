require 'spec_helper'

describe Ally::WebSocket do
  let(:dummy_socket) { DummySocket.new }
  let(:websocket)    { Ally::WebSocket.new dummy_socket, {} }
  let(:client_header) { dummy_socket.readpartial(4096) }

  # context "initialization" do
  #   it "should have the socket" do
  #     expect(websocket.instance_variable_get(:@socket)).to eq dummy_socket
  #   end

  #   it "should have a hash of options" do
  #     expect(websocket.instance_variable_get(:@options)).to eq({})
  #   end

  #   it "should create a new handshake object and read the clients header" do
  #     expect(websocket.instance_variable_get(:@handshake).valid?).to be_true
  #   end

  #   it "should get the  version from the header" do
  #     expect(websocket.version).to eq 13
  #   end

  #   it "should send the accept header back to the client" do
  #     dummy_socket.should_receive(:write)
  #     Ally::WebSocket.new dummy_socket, {}
  #   end
  # end
end

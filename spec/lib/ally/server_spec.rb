require 'rspec/autorun'
require 'spec_helper'

describe Ally::Server do
  let(:server) { Ally::Server.new }

  # These specs dont work with celluloid
  #
  # context "initialization" do
  #   before do
  #     TCPServer.stub(:new).and_return(Object.new)
  #   end

  #   it "should have a default host" do
  #     expect(server.instance_variable_get(:@host)).to eq "127.0.0.1"
  #   end

  #   it "should have a default port" do
  #     expect(server.instance_variable_get(:@port)).to eq 9292
  #   end

  #   it "should create a new TCPServer" do
  #     expect(server.instance_variable_get(:@server)).to_not be_nil
  #   end
  # end
end

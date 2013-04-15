require 'spec_helper'

class BindableDummy
  include Ally::Bindable

  attr_accessor :callbacks

  def initialize
    @callbacks = {}
  end

  def available_bindings
    [:onconnect, :onerror]
  end
end

describe Ally::Bindable do
  let(:dummy) { BindableDummy.new }

  before do
    dummy.bind(:onconnect) do |x, y|
      1001
    end
  end

  it "should bind a block to @callbacks" do
    expect(dummy.callbacks[:onconnect].call).to eq 1001
  end

  it "should execute the block when triggered" do
    expect(dummy.trigger(:onconnect, 1, 2)).to eq 1001
  end
end

require 'spec_helper'

describe Wocket::StatusCode do
  let(:status_code) { Wocket::StatusCode }

  it "should have a normal closure method" do
    expect(status_code.normal_closure).to eq({ code: 1000,
                                               description: "normal closure" })
  end

  it "should have a going away method" do
    expect(status_code.going_away).to eq({ code: 1001,
                                           description: "going away" })
  end

  it "should have a protocol error method" do
    expect(status_code.protocol_error).to eq({ code: 1002,
                                               description: "protocol error" })
  end

  it "should have a invalid data method" do
    expect(status_code.invalid_data).to eq({ code: 1003,
                                             description: "invalid data" })
  end

  it "should have a inconsistent data method" do
    expect(status_code.inconsistent_data).to eq({ code: 1007,
                                             description: "inconsistent data" })
  end

  it "should have a policy violation method" do
    expect(status_code.policy_violation).to eq({ code: 1008,
                                                 description: "policy violation" })
  end

  it "should have a too large method" do
    expect(status_code.too_large).to eq({ code: 1009,
                                          description: "too large" })
  end

  it "should have a extention error method" do
    expect(status_code.extention_error).to eq({ code: 1010,
                                                description: "extention error" })
  end

  it "should have a unexpected condition method" do
    expect(status_code.unexpected_condition).to eq({ code: 1011,
                                                description: "unexpected condition" })
  end
end

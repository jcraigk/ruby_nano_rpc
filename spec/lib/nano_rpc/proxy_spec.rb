# frozen_string_literal: true
require 'spec_helper'

# This spec covers both NanoRpc::Proxy and NanoRpc::ProxyContext

class ProxyExample
  def proxy_params
    { account: :address }
  end

  def proxy_methods
    {
      some_action: {
        required: %i[param1 param2],
        optional: %i[param3 param4]
      },
      proxytest_another_action: {},
      single_param_method: {
        required: %i[param1]
      }
    }
  end

  include NanoRpc::Proxy
end

RSpec.describe ProxyExample do
  subject { described_class.new }
  let(:addr1) { 'nano_address1' }
  let(:node) { spy('NanoRpc::Node') }
  let(:expected_proxy_methods) do
    %i[proxytest_another_action single_param_method some_action]
  end

  before do
    allow(NanoRpc).to receive(:node).and_return(node)
    allow(subject).to receive(:address).and_return(addr1)
    allow(node).to receive(:call).and_return(true)
  end

  context 'custom node' do
    let(:custom_node) { NanoRpc::Node.new(host: 'mynanonode', port: 1234) }
    subject { described_class.new(node: custom_node) }

    it 'uses the custom node' do
      expect(custom_node).to receive(:call).with(
        :proxytest_another_action, account: addr1
      )
      subject.proxytest_another_action
    end
  end

  it 'includes proxy_methods in #methods' do
    expect(subject.methods).to include(*subject.proxy_methods.keys)
  end

  it 'invokes the node with expected parameters' do
    expect(node).to receive(:call).with(
      :proxytest_another_action, account: addr1
    )
    subject.proxytest_another_action
  end

  context 'with single-key response matching method name' do
    before do
      allow(node).to receive(:call).and_return(
        proxytest_another_action: 'value'
      )
    end

    it 'returns nested values' do
      expect(subject.proxytest_another_action).to eq('value')
    end
  end

  it 'does not persist parameters across method calls' do
    subject.some_action(param1: 'value', param2: 'value')
    expect { subject.some_action(param1: 'value') }.to(
      raise_error(NanoRpc::MissingParameters)
    )
  end

  it 'defines instance proxy methods' do
    expect do
      subject.some_action(param1: 'value', param2: 'value')
    end.not_to raise_error
    expect { subject.proxytest_another_action }.not_to raise_error
  end

  it 'allows passing single literal to single-parameter methods' do
    expect(node).to receive(:call).with(
      :single_param_method, account: addr1, param1: 'value'
    )
    subject.single_param_method('value')
  end

  it 'does not define singleton proxy methods when proxy_params provided' do
    expect { described_class.some_action }.to raise_error(
      NoMethodError, "undefined method `some_action' for ProxyExample:Class"
    )
  end

  it 'provides respond_to? on proxy methods' do
    expect(subject.respond_to?(:some_action)).to eq(true)
    expect(subject.respond_to?(:proxytest_another_action)).to eq(true)
    expect(subject.respond_to?(:invalid_method)).to eq(false)
  end

  it 'raises MissingParameters when required parameters missing' do
    expect { subject.some_action(param1: 'value') }.to(
      raise_error(
        NanoRpc::MissingParameters,
        'Missing required parameter(s): param2'
      )
    )
  end

  it 'raises ForbiddenParameter when unexpected parameter passed' do
    expect do
      subject.some_action(
        param1: 'value',
        param2: 'value',
        param3: 'value',
        bad_param1: 'value',
        bad_param2: 'value'
      )
    end.to(
      raise_error(
        NanoRpc::ForbiddenParameter,
        'Forbidden parameter(s) passed: bad_param1, bad_param2'
      )
    )
  end
end

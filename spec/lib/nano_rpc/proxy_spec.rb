# frozen_string_literal: true
require 'spec_helper'

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

RSpec.describe NanoRpc::Proxy do
  subject(:proxy) { ProxyExample.new }

  let(:addr1) { 'nano_address1' }
  let(:node) { instance_double('NanoRpc::Node') }
  let(:expected_proxy_methods) do
    %i[proxytest_another_action single_param_method some_action]
  end

  before do
    allow(NanoRpc).to receive(:node).and_return(node)
    allow(proxy).to receive(:address).and_return(addr1)
    allow(node).to receive(:call).and_return(true)
  end

  describe 'custom node' do
    subject(:proxy) { ProxyExample.new(node: custom_node) }

    let(:custom_node) { NanoRpc::Node.new(host: 'mynanonode', port: 1234) }

    it 'uses the custom node' do
      allow(custom_node).to receive(:call).with(
        :proxytest_another_action, account: addr1
      )
      proxy.proxytest_another_action
      expect(custom_node).to have_received(:call)
    end
  end

  it 'defines proxy_methods on subject' do
    expected_proxy_methods.each do |meth|
      expect(proxy.respond_to?(meth)).to eq(true)
    end
  end

  it 'invokes the node with expected parameters' do
    allow(node).to receive(:call).with(
      :proxytest_another_action, account: addr1
    )
    proxy.proxytest_another_action
    expect(node).to have_received(:call)
  end

  context 'with single-key response matching method name' do
    before do
      allow(node).to receive(:call).and_return(
        proxytest_another_action: 'value'
      )
    end

    it 'returns nested values' do
      expect(proxy.proxytest_another_action).to eq('value')
    end
  end

  it 'does not persist parameters across method calls' do
    proxy.some_action(param1: 'value', param2: 'value')
    expect { proxy.some_action(param1: 'value') }.to(
      raise_error(NanoRpc::MissingParameters)
    )
  end

  it 'defines instance proxy methods' do
    expect do
      proxy.some_action(param1: 'value', param2: 'value')
    end.not_to raise_error
    expect { proxy.proxytest_another_action }.not_to raise_error
  end

  it 'allows passing single literal to single-parameter methods' do
    allow(node).to receive(:call).with(
      :single_param_method, account: addr1, param1: 'value'
    )
    proxy.single_param_method('value')
    expect(node).to have_received(:call)
  end

  it 'does not define singleton proxy methods when proxy_params provided' do
    expect { ProxyExample.some_action }.to raise_error(
      NoMethodError, "undefined method `some_action' for ProxyExample:Class"
    )
  end

  it 'provides respond_to? on proxy methods' do
    expect(proxy.respond_to?(:some_action)).to eq(true)
    expect(proxy.respond_to?(:proxytest_another_action)).to eq(true)
    expect(proxy.respond_to?(:invalid_method)).to eq(false)
  end

  it 'raises MissingParameters when required parameters missing' do
    expect { proxy.some_action(param1: 'value') }.to(
      raise_error(
        NanoRpc::MissingParameters,
        'Missing required parameter(s): param2'
      )
    )
  end

  context 'when unexpected parameters passed' do
    let(:invalid_params) do
      {
        param1: 'value',
        param2: 'value',
        param3: 'value',
        bad_param1: 'value',
        bad_param2: 'value'
      }
    end

    it 'raises ForbiddenParameter' do
      expect { proxy.some_action(invalid_params) }.to(
        raise_error(
          NanoRpc::ForbiddenParameter,
          'Forbidden parameter(s) passed: bad_param1, bad_param2'
        )
      )
    end
  end
end

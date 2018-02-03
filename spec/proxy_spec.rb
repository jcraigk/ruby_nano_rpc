# frozen_string_literal: true
require 'spec_helper'

# This spec covers both Nano::Proxy and Nano::ProxyContext

class ProxyExample
  include Nano::Proxy

  proxy_params account: :address
  proxy_method :some_action,
               required: %i[param1 param2], optional: %i[param3 param4]
  proxy_method :proxytest_another_action
end

RSpec.describe ProxyExample do
  subject { described_class.new }
  let(:addr1) { 'nano_address1' }
  let(:client) { spy('Nano::Client') }
  let(:expected_proxy_methods) { %i[proxytest_another_action some_action] }

  before do
    allow(Nano).to receive(:client).and_return(client)
    allow(subject).to receive(:address).and_return(addr1)
    allow(client).to receive(:call).and_return(true)
  end

  context 'custom client' do
    let(:custom_client) { Nano::Client.new(host: 'mynanonode', port: 1234) }
    subject { described_class.new(client: custom_client) }

    it 'uses the custom client' do
      expect(custom_client).to receive(:call).with(
        :proxytest_another_action, account: addr1
      )
      subject.proxytest_another_action
    end
  end

  it 'provides sorted list of methods' do
    expect(described_class.proxy_methods).to eq(expected_proxy_methods)
    expect(subject.proxy_methods).to eq(expected_proxy_methods)
  end

  it 'includes proxy_methods in #methods' do
    expect(described_class.methods).to include(*described_class.proxy_methods)
    expect(subject.methods).to include(*subject.proxy_methods)
  end

  it 'invokes the client with expected parameters' do
    expect(client).to receive(:call).with(
      :proxytest_another_action, account: addr1
    )
    subject.proxytest_another_action
  end

  context 'with single-key response matching method name' do
    before do
      allow(client).to receive(:call).and_return(
        proxytest_another_action: 'value'
      )
    end

    it 'returns nested values' do
      expect(subject.proxytest_another_action).to eq('value')
    end
  end

  it 'does not persist parameters across method calls' do
    subject.some_action(param1: 'true', param2: 'true')
    expect { subject.some_action(param1: 'true') }.to(
      raise_error(Nano::MissingParameters)
    )
  end

  it 'defines instance proxy methods' do
    expect do
      subject.some_action(param1: 'true', param2: 'true')
    end.not_to raise_error
    expect { subject.proxytest_another_action }.not_to raise_error
  end

  context 'no proxy_params defined' do
    before do
      allow(subject.class).to receive(:proxy_param_def).and_return(nil)
    end

    it 'defines singleton proxy methods' do
      expect do
        described_class.some_action(param1: '', param2: '')
      end.not_to raise_error
      expect do
        described_class.proxytest_another_action
      end.not_to raise_error
    end

    it 'provides respond_to? on proxy methods' do
      expect(described_class.respond_to?(:some_action)).to eq(true)
      expect(described_class.respond_to?(:proxytest_another_action)).to eq(true)
      expect(described_class.respond_to?(:invalid_method)).to eq(false)
    end
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
    expect { subject.some_action(param1: 'true') }.to(
      raise_error(
        Nano::MissingParameters,
        'Missing required parameter(s): param2'
      )
    )
  end

  it 'raises ForbiddenParameter when unexpected parameter passed' do
    expect do
      subject.some_action(
        param1: 'true',
        param2: 'true',
        param3: 'true',
        bad_param: 'true',
        bad_param2: 'true'
      )
    end.to(
      raise_error(
        Nano::ForbiddenParameter,
        'Forbidden parameter(s) passed: bad_param, bad_param2'
      )
    )
  end

  it 'raises InvalidParameterType when anything but hash is passed' do
    expect { subject.some_action(:bad_argument) }.to(
      raise_error(
        Nano::InvalidParameterType,
        'You must pass a hash to an action method'
      )
    )
  end
end

# frozen_string_literal: true
require 'spec_helper'

# This spec covers both Nano::Proxy and Nano::ProxyContext

class ProxyExample
  include Nano::Proxy

  proxy_params account: :address
  proxy_method :some_action,
               required: %i[param1 param2], optional: %i[param3 param4]
  proxy_method :proxytest_another_action
  proxy_method :single_param_method, required: %i[param1]
end

RSpec.describe ProxyExample do
  subject { described_class.new }
  let(:addr1) { 'nano_address1' }
  let(:client) { spy('Nano::Client') }
  let(:expected_proxy_methods) do
    %i[proxytest_another_action single_param_method some_action]
  end

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
    subject.some_action(param1: 'value', param2: 'value')
    expect { subject.some_action(param1: 'value') }.to(
      raise_error(Nano::MissingParameters)
    )
  end

  it 'defines instance proxy methods' do
    expect do
      subject.some_action(param1: 'value', param2: 'value')
    end.not_to raise_error
    expect { subject.proxytest_another_action }.not_to raise_error
  end

  it 'allows passing single literal to single-parameter methods' do
    expect(client).to receive(:call).with(
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
        Nano::MissingParameters,
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
        bad_param: 'value',
        bad_param2: 'value'
      )
    end.to(
      raise_error(
        Nano::ForbiddenParameter,
        'Forbidden parameter(s) passed: bad_param, bad_param2'
      )
    )
  end
end

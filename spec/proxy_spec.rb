# frozen_string_literal: true
RSpec.describe RaiblocksRpc::Proxy do
  subject { described_class.new }
  let(:client) { spy('RaiblocksRpc::Client') }

  before do
    allow(RaiblocksRpc).to receive(:client).and_return client
  end

  it 'requires child to implement `proxy_methods`' do
    expect { subject.send(:proxy_methods) }.to(
      raise_error(
        RuntimeError,
        'Child class must override `proxy_methods` method'
      )
    )
  end

  context 'when #proxy_params and #proxy_methods are provided' do
    let(:proxy_params) do
      { thing: :address }
    end
    let(:proxy_methods) do
      {
        some_action: {
          required: %i[param1 param2],
          optional: %i[param3 param4]
        },
        thing_another_action: nil
      }
    end
    let(:address) { 'xrb_someaddress12345' }

    before do
      allow(subject).to receive(:proxy_params).and_return(proxy_params)
      allow(subject).to receive(:proxy_methods).and_return(proxy_methods)

      # TODO actually test #action_prefix's behavior of using self.class.name
      allow(subject).to receive(:action_prefix).and_return('thing_')
      allow(subject).to receive(:address).and_return(address)
      allow(client).to receive(:call).and_return(true)
    end

    it 'invokes the client with expected parameters' do
      expect(client).to receive(:call).with(
        'thing_another_action', thing: address
      )
      subject.another_action
    end

    it 'does not persist parameters across method calls' do
      subject.some_action(param1: 'true', param2: 'true')
      expect { subject.some_action(param1: 'true') }.to(
        raise_error(RaiblocksRpc::MissingParameters)
      )
    end

    it 'defines convenience methods' do
      expect do
        subject.some_action(param1: 'true', param2: 'true')
      end.not_to raise_error
      expect { subject.thing_another_action }.not_to raise_error
      expect { subject.another_action }.not_to raise_error
    end

    it 'provides respond_to? on magic methods' do
      expect(subject.respond_to?(:some_action)).to eq(true)
      expect(subject.respond_to?(:thing_another_action)).to eq(true)
      expect(subject.respond_to?(:another_action)).to eq(true)
    end

    it 'raises MissingParameters when required parameters missing' do
      expect { subject.some_action(param1: 'true') }.to(
        raise_error(
          RaiblocksRpc::MissingParameters,
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
          RaiblocksRpc::ForbiddenParameter,
          'Forbidden parameter(s) passed: bad_param, bad_param2'
        )
      )
    end

    it 'raises InvalidParameterType when anything but hash is passed' do
      expect { subject.some_action(:bad_argument) }.to(
        raise_error(
          RaiblocksRpc::InvalidParameterType,
          'You must pass a hash to an action method'
        )
      )
    end
  end
end

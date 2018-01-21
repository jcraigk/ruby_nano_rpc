# frozen_string_literal: true
RSpec.describe RaiblocksRpc::Proxy do
  subject { described_class.new }

  it 'requires child to implement `model_params`' do
    expect { subject.send(:model_params) }.to(
      raise_error(
        RuntimeError,
        'Child class must override `model_params` method'
      )
    )
  end

  it 'requires child to implement `model_methods`' do
    expect { subject.send(:model_methods) }.to(
      raise_error(
        RuntimeError,
        'Child class must override `model_methods` method'
      )
    )
  end

  context 'when `model_params` and `model_methods` are provided' do
    let(:model_params) do
      { thing: :address }
    end
    let(:model_methods) do
      {
        some_action: {
          required: %i[param1 param2],
          optional: %i[param3 param4]
        },
        thing_another_action: nil
      }
    end

    before do
      allow(subject).to receive(:model_params).and_return(model_params)
      allow(subject).to receive(:model_methods).and_return(model_methods)
      allow(subject).to receive(:action_prefix).and_return('thing_')
      allow(subject).to receive(:address).and_return('xrb_someaddress12345')
    end

    it 'builds raw plus abbreviated action methods' do
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
      expect {
        subject.some_action(
          param1: 'true',
          param2: 'true',
          param3: 'true',
          bad_param: 'true',
          bad_param2: 'true'
        )
      }.to(
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

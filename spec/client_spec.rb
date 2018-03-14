# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Nano::Client do
  subject { described_class.new }
  let(:client_with_config) do
    described_class.new(host: '127.0.0.1', port: 7077)
  end
  let(:action) { 'account_balance' }
  let(:params) { { account: 'nano_address1' } }
  let(:valid_response_json) do
    { balance: 1000, pending: 1000 }.to_json
  end
  let(:bad_response_json) do
    { error: error_msg }.to_json
  end
  let(:error_msg) { 'Bad account number' }
  let(:seed1) { 'ABCDEF' }
  let(:addr1) { 'nano_address1' }
  let(:addr2) { 'nano_address2' }
  let(:addresses) { [addr1, addr2] }

  it 'provides a client instance on namespace' do
    expect(Nano.client.class).to eq(described_class)
  end

  it 'provides default configuration' do
    expect(subject.host).to eq('localhost')
    expect(subject.port).to eq(7076)
  end

  it 'allows host configuration' do
    expect(client_with_config.host).to eq('127.0.0.1')
    expect(client_with_config.port).to eq(7077)
  end

  it 'implements #call' do
    expect(subject).to receive(:rpc_post).with(
      { action: action }.merge(params)
    )
    subject.call(action, params)
  end

  context 'headers and RestClient' do
    let(:custom_headers) { { 'My-Header-X' => 'My-Value' } }
    let(:auth_key) { 'some_auth_key' }
    let(:client_with_headers) do
      described_class.new(auth: auth_key, headers: custom_headers)
    end

    it 'exposes auth instance var' do
      expect(client_with_headers.auth).to eq(auth_key)
    end

    it 'exposes headers instance var' do
      expect(client_with_headers.headers).to eq(custom_headers)
    end

    it '#call invokes RestClient#post with expected parameters' do
      expect(RestClient).to receive(:post).with(
        'http://localhost:7076',
        { action: :version },
        'Content-Type' => 'json',
        'Authorization' => auth_key,
        'My-Header-X' => 'My-Value'
      )
      expect do
        client_with_headers.call(:version)
      end.to raise_error(Nano::BadRequest)
    end
  end

  context 'node connection failure' do
    before do
      allow(RestClient).to receive(:post).and_raise(Errno::ECONNREFUSED)
    end

    it 'raises NodeConnectionFailure and provides error message' do
      expect { subject.call(action, params) }.to(
        raise_error(
          Nano::NodeConnectionFailure,
          'Node connection failure at http://localhost:7076'
        )
      )
    end
  end

  context 'node timeout' do
    before do
      allow(RestClient).to receive(:post).and_raise(
        RestClient::Exceptions::OpenTimeout
      )
    end

    it 'raises NodeConnectionFailure and provides error message' do
      expect { subject.call(action, params) }.to(
        raise_error(
          Nano::NodeOpenTimeout,
          'Node failed to respond in time'
        )
      )
    end
  end

  context 'handling server response' do
    let(:mock_response) { double }
    let(:client_call) { subject.call(action, params) }
    before do
      allow(RestClient).to receive(:post).and_return(mock_response)
    end

    context 'with status code 200' do
      before do
        allow(mock_response).to receive(:code).and_return(200)
        allow(mock_response).to receive(:body).and_return(response_json)
      end

      context 'with success response from node' do
        let(:response_json) { valid_response_json }

        it 'converts to Nano::Response' do
          response = client_call
          expect(response.class).to eq(Nano::Response)
          expect(response['balance']).to eq(1000)
        end
      end

      context 'with error response from node' do
        let(:response_json) { bad_response_json }

        it 'raises InvalidRequest and provides error message' do
          expect { client_call }.to(
            raise_error(
              Nano::InvalidRequest,
              "Invalid request: #{error_msg}"
            )
          )
        end
      end
    end

    context 'with status other than 200' do
      let(:response_body) { { some_key: 'some message' } }.to_json

      before do
        allow(mock_response).to receive(:code).and_return(500)
        allow(mock_response).to receive(:body).and_return(response_body)
      end

      it 'raises BadReques and provides body as string in error message' do
        expect { client_call }.to(
          raise_error(
            Nano::BadRequest,
            "Error response from node: #{JSON[response_body]}"
          )
        )
      end
    end
  end

  it 'combines host/port into url in #inspect output' do
    expect(subject.inspect).to include('@url="localhost:7076"')
  end

  context 'proxy objects' do
    it 'pulls #seed from Nano::Wallet' do
      expect(subject).to(
        receive(:rpc_post).with(action: action, wallet: seed1)
      )
      subject.call(action, wallet: Nano::Wallet.new(seed1))
    end

    it 'pulls #addresses from Nano::Accounts' do
      expect(subject).to(
        receive(:rpc_post).with(action: action, accounts: addresses)
      )
      subject.call(action, accounts: Nano::Accounts.new(addresses))
    end

    it 'pulls #address from Nano::Account' do
      expect(subject).to(
        receive(:rpc_post).with(action: action, account: addr1)
      )
      subject.call(action, account: Nano::Account.new(addr1))
    end
  end
end

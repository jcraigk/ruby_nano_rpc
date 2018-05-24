# frozen_string_literal: true
require 'spec_helper'

RSpec.describe NanoRpc::Node do
  subject { described_class.new }
  let(:node_with_config) do
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

  context 'proxy methods' do
    let(:expected_proxy_methods) do
      %i[
        available_supply
        block
        block_account
        block_confirm
        block_count
        block_count_type
        block_create
        blocks
        blocks_info
        bootstrap
        bootstrap_any
        chain
        confirmation_history
        deterministic_key
        frontier_count
        history
        keepalive
        key_create
        key_expand
        krai_from_raw
        krai_to_raw
        mrai_from_raw
        mrai_to_raw
        payment_wait
        peers
        pending_exists
        process
        rai_from_raw
        rai_to_raw
        receive_minimum
        receive_minimum_set
        representatives
        representatives_online
        republish
        search_pending
        search_pending_all
        stats
        stop
        successors
        unchecked
        unchecked_clear
        unchecked_get
        unchecked_keys
        version
        wallet_create
        work_cancel
        work_generate
        work_peer_add
        work_peers
        work_peers_clear
        work_validate
      ]
    end

    it 'defines expected proxy params and methods' do
      expect(described_class.proxy_param_def).to eq(nil)
      expect(described_class.proxy_methods).to eq(expected_proxy_methods)
    end
  end

  it 'provides a node instance on namespace' do
    expect(NanoRpc.node.class).to eq(described_class)
  end

  it 'provides default configuration' do
    expect(subject.host).to eq('localhost')
    expect(subject.port).to eq(7076)
  end

  context 'host protocol and port' do
    let(:host) { '127.0.0.1' }
    let(:url_with_http) { "http://#{host}" }
    let(:url_with_http_and_port) { "http://#{host}:7076" }
    let(:url_with_https) { "https://#{host}" }
    let(:url_with_https_and_port) { "https://#{host}:7076" }

    it 'adds http if missing' do
      subject = described_class.new(host: host)
      expect(subject.send(:url)).to eq(url_with_http_and_port)
      subject = described_class.new(host: url_with_http)
      expect(subject.send(:url)).to eq(url_with_http_and_port)
      subject = described_class.new(host: url_with_https)
      expect(subject.send(:url)).to eq(url_with_https_and_port)
    end
  end

  it 'allows host configuration' do
    expect(node_with_config.host).to eq('127.0.0.1')
    expect(node_with_config.port).to eq(7077)
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
    let(:node_with_headers) do
      described_class.new(auth: auth_key, headers: custom_headers)
    end

    it 'exposes auth instance var' do
      expect(node_with_headers.auth).to eq(auth_key)
    end

    it 'exposes headers instance var' do
      expect(node_with_headers.headers).to eq(custom_headers)
    end

    it '#call invokes RestClient#post with expected parameters' do
      expect(RestClient).to receive(:post).with(
        'http://localhost:7076',
        { action: :version }.to_json,
        'Content-Type' => 'json',
        'Authorization' => auth_key,
        'My-Header-X' => 'My-Value'
      )
      expect do
        node_with_headers.call(:version)
      end.to raise_error(NanoRpc::BadRequest)
    end
  end

  context 'node connection failure' do
    before do
      allow(RestClient).to receive(:post).and_raise(Errno::ECONNREFUSED)
    end

    it 'raises NodeConnectionFailure and provides error message' do
      expect { subject.call(action, params) }.to(
        raise_error(
          NanoRpc::NodeConnectionFailure,
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
          NanoRpc::NodeOpenTimeout,
          'Node failed to respond in time'
        )
      )
    end
  end

  context 'handling server response' do
    let(:mock_response) { double }
    let(:node_call) { subject.call(action, params) }
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

        it 'converts to NanoRpc::Response' do
          response = node_call
          expect(response.class).to eq(NanoRpc::Response)
          expect(response['balance']).to eq(1000)
        end
      end

      context 'with error response from node' do
        let(:response_json) { bad_response_json }

        it 'raises InvalidRequest and provides error message' do
          expect { node_call }.to(
            raise_error(
              NanoRpc::InvalidRequest,
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
        expect { node_call }.to(
          raise_error(
            NanoRpc::BadRequest,
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
    it 'pulls #seed from NanoRpc::Wallet' do
      expect(subject).to(
        receive(:rpc_post).with(action: action, wallet: seed1)
      )
      subject.call(action, wallet: NanoRpc::Wallet.new(seed1))
    end

    it 'pulls #addresses from NanoRpc::Accounts' do
      expect(subject).to(
        receive(:rpc_post).with(action: action, accounts: addresses)
      )
      subject.call(action, accounts: NanoRpc::Accounts.new(addresses))
    end

    it 'pulls #address from NanoRpc::Account' do
      expect(subject).to(
        receive(:rpc_post).with(action: action, account: addr1)
      )
      subject.call(action, account: NanoRpc::Account.new(addr1))
    end
  end
end

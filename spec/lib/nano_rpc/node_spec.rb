# frozen_string_literal: true
require 'spec_helper'

RSpec.describe NanoRpc::Node do
  subject(:node) { described_class.new }

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
  let(:wallet_id) { 'ABCDEF' }
  let(:addr1) { 'nano_address1' }
  let(:addr2) { 'nano_address2' }
  let(:addresses) { [addr1, addr2] }

  describe 'proxy methods' do
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
        bootstrap_lazy
        bootstrap_status
        chain
        confirmation_active
        confirmation_history
        confirmation_info
        confirmation_quorum
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
        node_id
        node_id_delete
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
        sign
        stats
        stats_clear
        stop
        successors
        unchecked
        unchecked_clear
        unchecked_get
        unchecked_keys
        uptime
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

    it 'defines expected proxy params' do
      expect(node.proxy_params).to eq({})
    end

    it 'defines expected proxy methods' do
      expect(node.proxy_methods.keys).to eq(expected_proxy_methods)
    end
  end

  it 'provides a node instance on namespace' do
    expect(NanoRpc.node.class).to eq(described_class)
  end

  it 'sets default config' do
    expect(node.host).to eq('localhost')
    expect(node.port).to eq(7076)
  end

  it 'allows custom config' do
    expect(node_with_config.host).to eq('127.0.0.1')
    expect(node_with_config.port).to eq(7077)
  end

  describe 'host protocol and port' do
    let(:host) { '127.0.0.1' }
    let(:url_with_http_and_port) { "http://#{host}:7076" }

    it 'adds http and port if missing' do
      node = described_class.new(host: host)
      expect(node.send(:url)).to eq(url_with_http_and_port)
    end

    it 'adds port if missing' do
      node = described_class.new(host: "http://#{host}")
      expect(node.send(:url)).to eq(url_with_http_and_port)
    end

    it 'adds http if missing' do
      node = described_class.new(host: "https://#{host}")
      expect(node.send(:url)).to eq("https://#{host}:7076")
    end
  end

  it 'implements #call' do
    allow(node).to receive(:rpc_post).with({ action: action }.merge(params))
    node.call(action, params)
    expect(node).to have_received(:rpc_post)
  end

  describe 'HTTP client' do
    let(:custom_headers) { { 'My-Header-X' => 'My-Value' } }
    let(:custom_timeout) { 10 }
    let(:auth_key) { 'some_auth_key' }
    let(:node_with_options) do
      described_class.new(
        auth: auth_key,
        headers: custom_headers,
        timeout: custom_timeout
      )
    end
    let(:url) { 'http://localhost:7076' }
    let(:options) do
      {
        body: { action: action }.merge(params).to_json,
        headers: {
          'Content-Type' => 'json',
          'Authorization' => auth_key,
          'My-Header-X' => 'My-Value'
        }
      }
    end
    let(:mock_http_client) { instance_spy(HTTP::Client) }
    let(:mock_response) { instance_spy(HTTP::Response) }
    let(:mock_body) { instance_spy(HTTP::Response::Body) }
    let(:node_call) { node_with_options.call(action, params) }

    it 'exposes instance vars' do
      expect(node_with_options.host).to eq('localhost')
      expect(node_with_options.port).to eq(7076)
    end

    describe 'things' do
      before do
        allow(HTTP).to(
          receive(:timeout).with(custom_timeout).and_return(mock_http_client)
        )
      end

      context 'when node refuses to connect' do
        before do
          allow(mock_http_client).to receive(:post).and_raise(HTTP::ConnectionError)
        end

        it 'raises NodeConnectionFailure and provides error message' do
          expect { node_call }.to(
            raise_error(
              NanoRpc::NodeConnectionFailure,
              'Node connection failure at http://localhost:7076'
            )
          )
        end
      end

      context 'when node times out' do
        before do
          allow(mock_http_client).to receive(:post).and_raise(HTTP::TimeoutError)
        end

        it 'raises NodeConnectionFailure and provides error message' do
          expect { node_call }.to(
            raise_error(NanoRpc::NodeTimeout, 'Node timeout')
          )
        end
      end

      context 'with successful response' do
        before do
          allow(mock_http_client).to(
            receive(:post).with(url, options).and_return(mock_response)
          )
          allow(mock_response).to receive(:body).and_return(mock_body)
          allow(mock_body).to receive(:to_s).and_return(response_json)
        end

        context 'when node responds successfully' do
          let(:response_json) { valid_response_json }

          it 'converts to NanoRpc::Response' do
            response = node_call
            expect(response.class).to eq(NanoRpc::Response)
            expect(response['balance']).to eq(1000)
          end
        end

        context 'when node responds with error' do
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
    end
  end

  it 'combines host/port into url in #inspect output' do
    expect(node.inspect).to include('@url="localhost:7076"')
  end

  describe 'proxy objects' do
    it 'pulls #id from NanoRpc::Wallet' do
      allow(node).to(
        receive(:rpc_post).with(action: action, wallet: wallet_id)
      )
      node.call(action, wallet: NanoRpc::Wallet.new(wallet_id))
      expect(node).to have_received(:rpc_post)
    end

    it 'pulls #addresses from NanoRpc::Accounts' do
      allow(node).to(
        receive(:rpc_post).with(action: action, accounts: addresses)
      )
      node.call(action, accounts: NanoRpc::Accounts.new(addresses))
      expect(node).to have_received(:rpc_post)
    end

    it 'pulls #address from NanoRpc::Account' do
      allow(node).to(
        receive(:rpc_post).with(action: action, account: addr1)
      )
      node.call(action, account: NanoRpc::Account.new(addr1))
      expect(node).to have_received(:rpc_post)
    end
  end
end

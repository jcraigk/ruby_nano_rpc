# frozen_string_literal: true
RSpec.describe Raiblocks::Client do
  subject { described_class.new }
  let(:client_with_config) do
    described_class.new(host: '127.0.0.1', port: 7077)
  end
  let(:action) { 'account_balance' }
  let(:params) { { account: 'xrb_address1' } }
  let(:valid_response_json) do
    { balance: 1000, pending: 1000 }.to_json
  end
  let(:bad_response_json) do
    { error: error_msg }.to_json
  end
  let(:error_msg) { 'Bad account number' }

  it 'provides a client instance on namespace' do
    expect(Raiblocks.client.class).to eq(described_class)
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
    expect(subject).to receive(:post).with(
      { action: action }.merge(params)
    )
    subject.call(action, params)
  end

  context 'node connection failure' do
    before do
      allow(RestClient).to receive(:post).and_raise(Errno::ECONNREFUSED)
    end

    it 'raises NodeConnectionFailure and provides error message' do
      expect { subject.call(action, params) }.to(
        raise_error(
          Raiblocks::NodeConnectionFailure,
          'Node connection failure at http://localhost:7076'
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

        it 'converts to Raiblocks::Response' do
          response = client_call
          expect(response.class).to eq(Raiblocks::Response)
          expect(response['balance']).to eq(1000)
        end
      end

      context 'with error response from node' do
        let(:response_json) { bad_response_json }

        it 'raises InvalidRequest and provides error message' do
          expect { client_call }.to(
            raise_error(
              Raiblocks::InvalidRequest,
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
            Raiblocks::BadRequest,
            "Error response from node: #{JSON[response_body]}"
          )
        )
      end
    end
  end
end

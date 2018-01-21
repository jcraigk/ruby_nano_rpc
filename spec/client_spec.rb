# frozen_string_literal: true
RSpec.describe RaiblocksRpc::Client do
  subject { described_class }
  let(:client) { subject.new }
  let(:action) { 'account_balance' }
  let(:params) { { account: 'xrb_someaddress12345' } }
  let(:valid_response_json) do
    { balance: 1000, pending: 1000 }.to_json
  end
  let(:bad_response_json) do
    { error: error_msg }.to_json
  end
  let(:error_msg) { 'Bad account number' }

  it 'provides a client instance' do
    expect(client).to be
  end

  it 'allows host configuration' do
    subject.host = '127.0.0.1'
    expect(subject.host).to eq('127.0.0.1')
    subject.port = 7077
    expect(subject.port).to eq(7077)
  end

  it 'implements #call' do
    expect(client).to receive(:post).with(
      { action: action }.merge(params)
    )
    client.call(action, params)
  end

  context 'handling server response' do
    let(:mock_response) { double }
    let(:client_call) { client.call(action, params) }
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

        it 'converts to RaiblocksRpc::Response' do
          response = client_call
          expect(response.class).to eq(RaiblocksRpc::Response)
          expect(response['balance']).to eq(1000)
        end
      end

      context 'with error response from node' do
        let(:response_json) { bad_response_json }

        it 'raises InvalidRequest and provides error message' do
          expect { client_call }.to(
            raise_error(
              RaiblocksRpc::InvalidRequest,
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
            RaiblocksRpc::BadRequest,
            "Error response from node: #{JSON[response_body]}"
          )
        )
      end
    end
  end
end

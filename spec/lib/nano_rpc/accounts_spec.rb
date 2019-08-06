# frozen_string_literal: true

require 'spec_helper'

RSpec.describe NanoRpc::Accounts do
  subject(:accounts) { described_class.new(addresses) }

  let(:addresses) { %w[nano_address1 xrb_address2 xrb_address3] }
  let(:expected_proxy_methods) do
    %i[
      account_move
      accounts_balances
      accounts_create
      accounts_frontiers
      accounts_pending
    ]
  end
  let(:expected_proxy_params) { { accounts: :addresses } }

  it 'declares proxy params' do
    expect(accounts.proxy_params).to eq(expected_proxy_params)
  end

  it 'declares proxy methods' do
    expect(accounts.proxy_methods.keys).to eq(expected_proxy_methods)
  end

  it 'raises MissingParameters unless initialized with array' do
    expect { described_class.new }.to raise_error(
      NanoRpc::MissingParameters, 'Missing argument: addresses (str[])'
    )
  end

  it 'assigns address on initialization' do
    expect(accounts.addresses).to eq(addresses)
  end

  it 'has a custom #inspect' do
    expect(accounts.inspect).to include("@addresses=\"#{accounts.addresses}\"")
  end
end

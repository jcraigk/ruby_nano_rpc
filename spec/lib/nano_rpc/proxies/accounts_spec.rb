# frozen_string_literal: true
require 'spec_helper'

RSpec.describe NanoRpc::Accounts do
  subject { described_class.new(addresses) }
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

  it 'declares expected proxy params and methods' do
    expect(subject.proxy_params).to eq(expected_proxy_params)
    expect(subject.proxy_methods.keys).to eq(expected_proxy_methods)
  end

  it 'raises MissingParameters unless initialized with array' do
    expect { described_class.new }.to raise_error(
      NanoRpc::MissingParameters, 'Missing argument: addresses (str[])'
    )
  end

  it 'assigns address on initialization' do
    expect(subject.addresses).to eq(addresses)
  end

  it 'has a custom #inspect' do
    expect(subject.inspect).to include("@addresses=\"#{subject.addresses}\"")
  end
end

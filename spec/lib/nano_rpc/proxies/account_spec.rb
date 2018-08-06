# frozen_string_literal: true
require 'spec_helper'

RSpec.describe NanoRpc::Account do
  subject { described_class.new(address) }
  let(:address) { 'nano_address1' }
  let(:expected_proxy_methods) do
    %i[
      account_balance
      account_block_count
      account_create
      account_history
      account_info
      account_key
      account_move
      account_remove
      account_representative
      account_representative_set
      account_weight
      delegators
      delegators_count
      frontiers
      ledger
      payment_wait
      pending
      receive
      validate_account_number
      work_get
      work_set
    ]
  end
  let(:expected_proxy_params) { { account: :address } }

  it 'defines expected proxy params and methods' do
    expect(subject.proxy_params).to eq(expected_proxy_params)
    expect(subject.proxy_methods.keys).to eq(expected_proxy_methods)
  end

  it 'raises MissingParameters unless initialized with string' do
    expect { described_class.new }.to raise_error(
      NanoRpc::MissingParameters, 'Missing argument: address (str)'
    )
  end

  it 'assigns address on initialization' do
    expect(subject.address).to eq(address)
  end

  context 'with a balance' do
    let(:balance) { 100 }

    before do
      allow(subject).to receive(:account_balance).and_return(
        NanoRpc::Response.new('balance' => balance, 'pending' => 59)
      )
    end

    it 'provides #balance' do
      expect(subject.balance).to eq(balance)
    end
  end
end

# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Nano::Accounts do
  subject { described_class.new(addresses) }
  let(:addresses) { %w[nano_address1 xrb_address2 xrb_address3] }
  let(:additional_address) { 'xrb_address4' }
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
    expect(described_class.proxy_param_def).to eq(expected_proxy_params)
    expect(described_class.proxy_methods).to eq(expected_proxy_methods)
  end

  it 'raises MissingParameters unless initialized with array' do
    expect { described_class.new }.to raise_error(
      Nano::MissingParameters, 'Missing argument: addresses (str[])'
    )
  end

  it 'assigns address on initialization' do
    expect(subject.addresses).to eq(addresses)
  end

  it 'provides Array-like read access to Nano::Account objects' do
    expect(subject[0].class).to eq(Nano::Account)
    expect(subject[1].class).to eq(Nano::Account)
    expect(subject[2].class).to eq(Nano::Account)
    expect(subject[3]).to eq(nil)
    expect(subject.first).to eq(subject[0])
    expect(subject.second).to eq(subject[1])
    expect(subject.third).to eq(subject[2])
  end

  it 'provides `<<` addition of wallet addresss' do
    subject << additional_address
    expect(subject[3].class).to eq(Nano::Account)
    expect(subject[3].address).to eq(additional_address)
  end

  it 'provides #each iteration' do
    idx = 0
    subject.each do |account|
      expect(account.class).to eq(Nano::Account)
      expect(account.address).to eq(addresses[idx])
      idx += 1
    end
  end
end

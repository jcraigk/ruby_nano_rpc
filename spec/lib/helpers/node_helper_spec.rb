# frozen_string_literal: true
require 'spec_helper'

class NodeHelperExample
  include NanoRpc::Proxy
  include NanoRpc::NodeHelper
end

RSpec.describe NodeHelperExample do
  subject { NanoRpc::Node.new }
  let(:nano_amount) { 1_000_000_000_000_000_000_000_000 }
  let(:knano_amount) { 1_000_000_000_000_000_000_000_000_000 }
  let(:mnano_amount) { 1_000_000_000_000_000_000_000_000_000_000 }
  let(:knano_amount_param) { { amount: knano_amount } }
  let(:mnano_amount_param) { { amount: mnano_amount } }
  let(:nano_amount_param) { { amount: nano_amount } }
  let(:pending_hash) { '000BDE' }
  let(:work_params) { { work: '2def', hash: '000DEF' } }
  let(:addr1) { 'nano_address1' }
  let(:seed1) { 'A0BF3C' }
  let(:amount_param) { { amount: 1 } }
  let(:pending_hash_param) { { hash: pending_hash } }
  let(:addresses) { %w[abc def] }

  context 'proxy object wrappers' do
    it 'provides #wallet' do
      expect(NanoRpc::Wallet).to receive(:new).with(seed1, node: subject)
      subject.wallet(seed1)
    end

    it 'provides #account' do
      expect(NanoRpc::Account).to receive(:new).with(addr1, node: subject)
      subject.account(addr1)
    end

    it 'provides #accounts' do
      expect(NanoRpc::Accounts).to receive(:new).with(addresses, node: subject)
      subject.accounts(addresses)
    end
  end

  it 'provides #account_containing_block' do
    allow(subject).to(
      receive(:block_account)
        .with(pending_hash_param)
        .and_return(NanoRpc::Response.new('account' => addr1))
    )
    expect(subject.account_containing_block(pending_hash_param)).to eq(addr1)
  end

  it 'provides #total_supply' do
    allow(subject).to receive(:available_supply).and_return(
      NanoRpc::Response.new('available' => '200')
    )
    expect(subject.total_supply).to eq(200)
  end

  it 'provides #create_wallet' do
    allow(subject).to receive(:wallet_create).and_return(
      NanoRpc::Response.new('wallet' => seed1)
    )
    wallet = subject.create_wallet
    expect(wallet.class).to eq(NanoRpc::Wallet)
    expect(wallet.seed).to eq(seed1)
  end

  it 'provides #num_frontiers' do
    allow(subject).to receive(:frontier_count).and_return(
      NanoRpc::Response.new('count' => 100)
    )
    expect(subject.num_frontiers).to eq(100)
  end

  it 'provides #knano_from_raw' do
    allow(subject).to(
      receive(:krai_from_raw)
        .with(knano_amount_param)
        .and_return(NanoRpc::Response.new('amount' => '1'))
    )
    expect(subject.knano_from_raw(knano_amount_param)).to eq(1)
  end

  it 'provides #knano_to_raw' do
    allow(subject).to(
      receive(:krai_to_raw)
        .with(amount_param)
        .and_return(NanoRpc::Response.new('amount' => knano_amount.to_s))
    )
    expect(subject.knano_to_raw(amount_param)).to eq(knano_amount)
  end

  it 'provides #mnano_from_raw' do
    allow(subject).to(
      receive(:mrai_from_raw)
        .with(mnano_amount_param)
        .and_return(NanoRpc::Response.new('amount' => '1'))
    )
    expect(subject.mnano_from_raw(mnano_amount_param)).to eq(1)
  end

  it 'provides #mnano_to_raw' do
    allow(subject).to(
      receive(:mrai_to_raw)
        .with(amount_param)
        .and_return(NanoRpc::Response.new('amount' => mnano_amount.to_s))
    )
    expect(subject.mnano_to_raw(amount_param)).to eq(mnano_amount)
  end

  it 'provides #nano_from_raw' do
    allow(subject).to(
      receive(:rai_from_raw)
        .with(nano_amount_param)
        .and_return(NanoRpc::Response.new('amount' => '1'))
    )
    expect(subject.nano_from_raw(nano_amount_param)).to eq(1)
  end

  it 'provides #nano_to_raw' do
    allow(subject).to(
      receive(:rai_to_raw)
        .with(amount_param)
        .and_return(NanoRpc::Response.new('amount' => nano_amount.to_s))
    )
    expect(subject.nano_to_raw(amount_param)).to eq(nano_amount)
  end

  it 'provides #pending_exists?' do
    allow(subject).to(
      receive(:pending_exists)
        .with(pending_hash_param)
        .and_return(NanoRpc::Response.new('exists' => '1'))
    )
    expect(subject.pending_exists?(pending_hash_param)).to eq(true)
  end

  it 'provides #pending_exists?' do
    allow(subject).to(
      receive(:work_validate)
        .with(work_params)
        .and_return(NanoRpc::Response.new('valid' => '1'))
    )
    expect(subject.work_valid?(work_params)).to eq(true)
  end
end

# frozen_string_literal: true
require 'spec_helper'

class NodeHelper
  include NanoRpc::Proxy
  include NanoRpc::NodeHelper
end

RSpec.describe NodeHelper do
  subject(:node) { NanoRpc::Node.new }

  let(:nano_amount) { 1_000_000_000_000_000_000_000_000 }
  let(:knano_amount) { 1_000_000_000_000_000_000_000_000_000 }
  let(:mnano_amount) { 1_000_000_000_000_000_000_000_000_000_000 }
  let(:knano_amount_param) { { amount: knano_amount } }
  let(:mnano_amount_param) { { amount: mnano_amount } }
  let(:nano_amount_param) { { amount: nano_amount } }
  let(:pending_hash) { '000BDE' }
  let(:work_params) { { work: '2def', hash: '000DEF' } }
  let(:addr1) { 'nano_address1' }
  let(:wallet_id1) { 'A0BF3C' }
  let(:amount_param) { { amount: 1 } }
  let(:pending_hash_param) { { hash: pending_hash } }
  let(:addresses) { %w[abc def] }

  describe 'proxy object wrappers' do
    it 'provides #wallet' do
      allow(NanoRpc::Wallet).to receive(:new).with(wallet_id1, node: node)
      node.wallet(wallet_id1)
      expect(NanoRpc::Wallet).to have_received(:new)
    end

    it 'provides #account' do
      allow(NanoRpc::Account).to receive(:new).with(addr1, node: node)
      node.account(addr1)
      expect(NanoRpc::Account).to have_received(:new)
    end

    it 'provides #accounts' do
      allow(NanoRpc::Accounts).to receive(:new).with(addresses, node: node)
      node.accounts(addresses)
      expect(NanoRpc::Accounts).to have_received(:new)
    end
  end

  it 'provides #account_containing_block' do
    allow(node).to(
      receive(:block_account)
        .with(pending_hash_param)
        .and_return(NanoRpc::Response.new('account' => addr1))
    )
    expect(node.account_containing_block(pending_hash_param)).to eq(addr1)
  end

  it 'provides #total_supply' do
    allow(node).to receive(:available_supply).and_return(
      NanoRpc::Response.new('available' => '200')
    )
    expect(node.total_supply).to eq(200)
  end

  it 'provides #create_wallet' do
    allow(node).to receive(:wallet_create).and_return(
      NanoRpc::Response.new('wallet' => wallet_id1)
    )
    wallet = node.create_wallet
    expect(wallet.class).to eq(NanoRpc::Wallet)
    expect(wallet.id).to eq(wallet_id1)
  end

  it 'provides #num_frontiers' do
    allow(node).to receive(:frontier_count).and_return(
      NanoRpc::Response.new('count' => 100)
    )
    expect(node.num_frontiers).to eq(100)
  end

  it 'provides #knano_from_raw' do
    allow(node).to(
      receive(:krai_from_raw)
        .with(knano_amount_param)
        .and_return(NanoRpc::Response.new('amount' => '1'))
    )
    expect(node.knano_from_raw(knano_amount_param)).to eq(1)
  end

  it 'provides #knano_to_raw' do
    allow(node).to(
      receive(:krai_to_raw)
        .with(amount_param)
        .and_return(NanoRpc::Response.new('amount' => knano_amount.to_s))
    )
    expect(node.knano_to_raw(amount_param)).to eq(knano_amount)
  end

  it 'provides #mnano_from_raw' do
    allow(node).to(
      receive(:mrai_from_raw)
        .with(mnano_amount_param)
        .and_return(NanoRpc::Response.new('amount' => '1'))
    )
    expect(node.mnano_from_raw(mnano_amount_param)).to eq(1)
  end

  it 'provides #mnano_to_raw' do
    allow(node).to(
      receive(:mrai_to_raw)
        .with(amount_param)
        .and_return(NanoRpc::Response.new('amount' => mnano_amount.to_s))
    )
    expect(node.mnano_to_raw(amount_param)).to eq(mnano_amount)
  end

  it 'provides #nano_from_raw' do
    allow(node).to(
      receive(:rai_from_raw)
        .with(nano_amount_param)
        .and_return(NanoRpc::Response.new('amount' => '1'))
    )
    expect(node.nano_from_raw(nano_amount_param)).to eq(1)
  end

  it 'provides #nano_to_raw' do
    allow(node).to(
      receive(:rai_to_raw)
        .with(amount_param)
        .and_return(NanoRpc::Response.new('amount' => nano_amount.to_s))
    )
    expect(node.nano_to_raw(amount_param)).to eq(nano_amount)
  end

  it 'provides #pending_exists?' do
    allow(node).to(
      receive(:pending_exists)
        .with(pending_hash_param)
        .and_return(NanoRpc::Response.new('exists' => '1'))
    )
    expect(node.pending_exists?(pending_hash_param)).to eq(true)
  end

  it 'provides #work_valid?' do
    allow(node).to(
      receive(:work_validate)
        .with(work_params)
        .and_return(NanoRpc::Response.new('valid' => '1'))
    )
    expect(node.work_valid?(work_params)).to eq(true)
  end
end

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

  describe '#account_containing_block' do
    before do
      allow(node).to(
        receive(:block_account)
          .with(pending_hash_param)
          .and_return(NanoRpc::Response.new('account' => addr1))
      )
    end

    it 'returns expected value' do
      expect(node.account_containing_block(pending_hash_param)).to eq(addr1)
    end
  end

  it 'provides #clear_stats' do
    allow(node).to(
      receive(:stats_clear)
        .and_return(NanoRpc::Response.new('success' => ''))
    )
    expect(node.clear_stats).to eq(true)
  end

  it 'provides #total_supply' do
    allow(node).to receive(:available_supply).and_return(
      NanoRpc::Response.new('available' => '200')
    )
    expect(node.total_supply).to eq(200)
  end

  describe '#create_wallet' do
    let(:wallet) { node.create_wallet(seed: 'myseed') }

    before do
      allow(node).to(
        receive(:wallet_create)
          .with(seed: 'myseed')
          .and_return(
            NanoRpc::Response.new('wallet' => wallet_id1)
          )
      )
    end

    it 'provides wallet of expected class' do
      expect(wallet.class).to eq(NanoRpc::Wallet)
    end

    it 'sets expected id' do
      expect(wallet.id).to eq(wallet_id1)
    end
  end

  it 'provides #num_frontiers' do
    allow(node).to receive(:frontier_count).and_return(
      NanoRpc::Response.new('count' => 100)
    )
    expect(node.num_frontiers).to eq(100)
  end

  describe '#knano_from_raw' do
    before do
      allow(node).to(
        receive(:krai_from_raw)
          .with(knano_amount_param)
          .and_return(NanoRpc::Response.new('amount' => '1'))
      )
    end

    it 'returns expected value' do
      expect(node.knano_from_raw(knano_amount_param)).to eq(1)
    end
  end

  describe '#knano_to_raw' do
    before do
      allow(node).to(
        receive(:krai_to_raw)
          .with(amount_param)
          .and_return(NanoRpc::Response.new('amount' => knano_amount.to_s))
      )
    end

    it 'returns expected value' do
      expect(node.knano_to_raw(amount_param)).to eq(knano_amount)
    end
  end

  describe '#mnano_from_raw' do
    before do
      allow(node).to(
        receive(:mrai_from_raw)
          .with(mnano_amount_param)
          .and_return(NanoRpc::Response.new('amount' => '1'))
      )
    end

    it 'returns expected value' do
      expect(node.mnano_from_raw(mnano_amount_param)).to eq(1)
    end
  end

  describe '#mnano_to_raw' do
    before do
      allow(node).to(
        receive(:mrai_to_raw)
          .with(amount_param)
          .and_return(NanoRpc::Response.new('amount' => mnano_amount.to_s))
      )
    end

    it 'returns expected value' do
      expect(node.mnano_to_raw(amount_param)).to eq(mnano_amount)
    end
  end

  describe '#nano_from_raw' do
    before do
      allow(node).to(
        receive(:rai_from_raw)
          .with(nano_amount_param)
          .and_return(NanoRpc::Response.new('amount' => '1'))
      )
    end

    it 'returns expected value' do
      expect(node.nano_from_raw(nano_amount_param)).to eq(1)
    end
  end

  describe '#nano_to_raw' do
    before do
      allow(node).to(
        receive(:rai_to_raw)
          .with(amount_param)
          .and_return(NanoRpc::Response.new('amount' => nano_amount.to_s))
      )
    end

    it 'returns expected value' do
      expect(node.nano_to_raw(amount_param)).to eq(nano_amount)
    end
  end

  describe '#pending_exists?' do
    before do
      allow(node).to(
        receive(:pending_exists)
          .with(pending_hash_param)
          .and_return(NanoRpc::Response.new('exists' => '1'))
      )
    end

    it 'returns expected value' do
      expect(node.pending_exists?(pending_hash_param)).to eq(true)
    end
  end

  describe '#work_valid?' do
    before do
      allow(node).to(
        receive(:work_validate)
          .with(work_params)
          .and_return(NanoRpc::Response.new('valid' => '1'))
      )
    end

    it 'returns expected value' do
      expect(node.work_valid?(work_params)).to eq(true)
    end
  end
end

# frozen_string_literal: true
require 'spec_helper'

class AccountHelper
  include NanoRpc::AccountHelper
end

RSpec.describe AccountHelper do
  subject(:account) { NanoRpc::Account.new('abc') }

  let(:history_data) do
    [{ 'hash' => wallet_id1 }, { 'hash' => wallet_id1 }]
  end
  let(:info_data) do
    { 'frontier' => addr1, 'open_block' => wallet_id1 }
  end
  let(:account_move_params) { { from: wallet_id1, to: 'DEF' } }
  let(:account_move_opts) do
    { wallet: 'DEF', source: wallet_id1, accounts: [addr1] }
  end
  let(:addr1) { 'nano_address1' }
  let(:addr2) { 'nano_address2' }
  let(:wallet_id1) { 'A4C1EF' }
  let(:wallet_id2) { 'F9CD82' }
  let(:wallet_ids) { [wallet_id1, wallet_id2] }
  let(:work1) { '000000' }
  let(:pending_blocks_data) { { count: 1, threshold: '1000', source: true } }
  let(:balance_data) { { 'balance' => '100', 'pending' => '5' } }
  let(:wallet_work_params) { { wallet: wallet_id1, work: work1 } }
  let(:rep_set_params) { { wallet: wallet_id1, representative: addr1 } }
  let(:wallet) { NanoRpc::Wallet.new(wallet_id1) }
  let(:wallet2) { NanoRpc::Wallet.new(wallet_id2) }

  it 'provides #balance' do
    allow(account).to receive(:account_balance).and_return(
      NanoRpc::Response.new(balance_data)
    )
    expect(account.balance).to eq(100)
  end

  it 'provides #block_count' do
    allow(account).to receive(:account_block_count).and_return(
      NanoRpc::Response.new('block_count' => '5')
    )
    expect(account.block_count).to eq(5)
  end

  it 'provides #history' do
    allow(account).to(
      receive(:account_history)
        .with(count: 2)
        .and_return(NanoRpc::Response.new('history' => history_data))
    )
    expect(account.history(count: 2)).to eq(history_data)
  end

  it 'provides #info' do
    allow(account).to(
      receive(:account_info).and_return(NanoRpc::Response.new(info_data))
    )
    expect(account.info).to eq(info_data)
  end

  it 'provides #key' do
    allow(account).to(
      receive(:account_key).and_return(
        NanoRpc::Response.new('key' => wallet_id1)
      )
    )
    expect(account.key).to eq(wallet_id1)
  end

  it 'provides #move' do
    allow(account).to receive(:address).and_return(addr1)
    allow(account).to(
      receive(:account_move)
        .with(account_move_opts)
        .and_return(NanoRpc::Response.new('moved' => '1'))
    )
    expect(account.move(account_move_params)).to eq(true)
  end

  it 'provides #wallet_work_set' do
    allow(account).to(
      receive(:work_set)
        .with(wallet_work_params)
        .and_return(NanoRpc::Response.new('success' => ''))
    )
    expect(account.wallet_work_set(wallet_work_params)).to eq(true)
  end

  it 'provides #pending_balance and #balance_pending' do
    allow(account).to(
      receive(:account_balance)
        .and_return(NanoRpc::Response.new(balance_data))
    )
    expect(account.pending_balance).to eq(5)
    expect(account.balance_pending).to eq(5)
  end

  it 'provides #pending_blocks and #blocks_pending' do
    allow(account).to(
      receive(:pending)
        .with(pending_blocks_data)
        .and_return(NanoRpc::Response.new('blocks' => wallet_ids))
    )
    expect(account.pending_blocks(pending_blocks_data)).to eq(wallet_ids)
    expect(account.blocks_pending(pending_blocks_data)).to eq(wallet_ids)
  end

  it 'provides #remove' do
    allow(account).to(
      receive(:account_remove)
        .with(wallet: wallet_id1)
        .and_return(NanoRpc::Response.new('removed' => '1'))
    )
    expect(account.remove(wallet: wallet_id1)).to eq(true)
  end

  it 'provides #representative' do
    allow(account).to(
      receive(:account_representative)
        .and_return(NanoRpc::Response.new('representative' => addr1))
    )
    expect(account.representative).to eq(addr1)
  end

  it 'provides #representative_set' do
    allow(account).to(
      receive(:account_representative_set)
        .with(rep_set_params)
        .and_return(NanoRpc::Response.new('set' => '1'))
    )
    expect(account.representative_set(rep_set_params)).to eq(true)
  end

  it 'provides #valid?' do
    allow(account).to(
      receive(:validate_account_number)
        .and_return(NanoRpc::Response.new('valid' => '1'))
    )
    expect(account.valid?).to eq(true)
  end

  it 'provides #weight' do
    allow(account).to(
      receive(:account_weight)
        .and_return(NanoRpc::Response.new('weight' => '1000'))
    )
    expect(account.weight).to eq(1000)
  end
end

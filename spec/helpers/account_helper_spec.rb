# frozen_string_literal: true
require 'spec_helper'

class AccountHelperExample
  include Nano::AccountHelper
end

RSpec.describe AccountHelperExample do
  subject { described_class.new }
  let(:history_data) do
    [{ 'hash' => seed1 }, { 'hash' => seed1 }]
  end
  let(:info_data) do
    { 'frontier' => addr1, 'open_block' => seed1 }
  end
  let(:account_move_params) { { from: seed1, to: 'DEF' } }
  let(:account_move_opts) do
    { wallet: 'DEF', source: seed1, accounts: [addr1] }
  end
  let(:account_move_opts2) do
    {
      source: wallet.seed,
      wallet: wallet2.seed,
      accounts: [addr1]
    }
  end
  let(:addr1) { 'nano_address1' }
  let(:addr2) { 'nano_address2' }
  let(:seed1) { 'A4C1EF' }
  let(:seed2) { 'F9CD82' }
  let(:seeds) { [seed1, seed2] }
  let(:work1) { '000000' }
  let(:pending_blocks_data) { { count: 1, threshold: '1000', source: true } }
  let(:balance_data) { { 'balance' => '100', 'pending' => '5' } }
  let(:wallet_work_params) { { wallet: seed1, work: work1 } }
  let(:rep_set_params) { { wallet: seed1, representative: addr1 } }
  let(:wallet) { Nano::Wallet.new(seed1) }
  let(:wallet2) { Nano::Wallet.new(seed2) }

  it 'provides #balance' do
    allow(subject).to receive(:account_balance).and_return(
      Nano::Response.new(balance_data)
    )
    expect(subject.balance).to eq(100)
  end

  it 'provides #block_count' do
    allow(subject).to receive(:account_block_count).and_return(
      Nano::Response.new('block_count' => '5')
    )
    expect(subject.block_count).to eq(5)
  end

  it 'provides #history' do
    allow(subject).to(
      receive(:account_history)
        .with(count: 2)
        .and_return(Nano::Response.new('history' => history_data))
    )
    expect(subject.history(count: 2)).to eq(history_data)
  end

  it 'provides #info' do
    allow(subject).to(
      receive(:account_info).and_return(Nano::Response.new(info_data))
    )
    expect(subject.info).to eq(info_data)
  end

  it 'provides #key' do
    allow(subject).to(
      receive(:account_key).and_return(Nano::Response.new('key' => seed1))
    )
    expect(subject.key).to eq(seed1)
  end

  it 'provides #move' do
    allow(subject).to receive(:address).and_return(addr1)
    allow(subject).to(
      receive(:account_move)
        .with(account_move_opts)
        .and_return(Nano::Response.new('moved' => '1'))
    )
    expect(subject.move(account_move_params)).to eq(true)
  end

  it 'provides #wallet_work_set' do
    allow(subject).to(
      receive(:work_set)
        .with(wallet_work_params)
        .and_return(Nano::Response.new('success' => ''))
    )
    expect(subject.wallet_work_set(wallet_work_params)).to eq(true)
  end

  it 'provides #pending_balance and #balance_pending' do
    allow(subject).to(
      receive(:account_balance)
        .and_return(Nano::Response.new(balance_data))
    )
    expect(subject.pending_balance).to eq(5)
    expect(subject.balance_pending).to eq(5)
  end

  it 'provides #pending_blocks and #blocks_pending' do
    allow(subject).to(
      receive(:pending)
        .with(pending_blocks_data)
        .and_return(Nano::Response.new('blocks' => seeds))
    )
    expect(subject.pending_blocks(pending_blocks_data)).to eq(seeds)
    expect(subject.blocks_pending(pending_blocks_data)).to eq(seeds)
  end

  it 'provides #remove' do
    allow(subject).to(
      receive(:account_remove)
        .with(wallet: seed1)
        .and_return(Nano::Response.new('removed' => '1'))
    )
    expect(subject.remove(wallet: seed1)).to eq(true)
  end

  it 'provides #representative' do
    allow(subject).to(
      receive(:account_representative)
        .and_return(Nano::Response.new('representative' => addr1))
    )
    expect(subject.representative).to eq(addr1)
  end

  it 'provides #representative_set' do
    allow(subject).to(
      receive(:account_representative_set)
        .with(rep_set_params)
        .and_return(Nano::Response.new('set' => '1'))
    )
    expect(subject.representative_set(rep_set_params)).to eq(true)
  end

  it 'provides #weight' do
    allow(subject).to(
      receive(:account_weight)
        .and_return(Nano::Response.new('weight' => '1000'))
    )
    expect(subject.weight).to eq(1000)
  end
end

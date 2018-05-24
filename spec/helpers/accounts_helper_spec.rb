# frozen_string_literal: true
require 'spec_helper'

class AccountsHelperExample
  include NanoRpc::AccountsHelper
end

RSpec.describe AccountsHelperExample do
  subject { described_class.new }
  let(:addr1) { 'nano_address1' }
  let(:addr2) { 'nano_address2' }
  let(:block1) { '9FE23A' }
  let(:block2) { '1ACFF4' }
  let(:seed1) { 'ABCDEF' }
  let(:seed2) { '298EDA' }
  let(:balances_data) do
    {
      'balances' => {
        addr1 => { 'balance' => 100, 'pending' => 2 },
        addr2 => { 'balance' => 50, 'pending' => 3 }
      }
    }
  end
  let(:frontiers_data) { { 'frontiers' => frontiers_hash } }
  let(:frontiers_hash) { { addr1 => block1, addr2 => block2 } }
  let(:pending_hash) { { addr1 => [block1], addr2 => [block2] } }
  let(:pending_params) { { count: 1, threshold: 100, source: true } }

  it 'provides #balances' do
    allow(subject).to receive(:accounts_balances).and_return(
      NanoRpc::Response.new(balances_data)
    )
    expect(subject.balances).to eq(addr1 => 100, addr2 => 50)
  end

  it 'provides #pending_balances and #balances_pending' do
    allow(subject).to receive(:accounts_balances).and_return(
      NanoRpc::Response.new(balances_data)
    )
    expect(subject.pending_balances).to eq(addr1 => 2, addr2 => 3)
    expect(subject.balances_pending).to eq(addr1 => 2, addr2 => 3)
  end

  it 'provides #frontiers' do
    allow(subject).to receive(:accounts_frontiers).and_return(
      NanoRpc::Response.new(frontiers_data)
    )
    expect(subject.frontiers).to eq(frontiers_hash)
  end

  it 'provides #move' do
    allow(subject).to receive(:account_move)
      .with(wallet: seed2, source: seed1)
      .and_return(NanoRpc::Response.new('moved' => '1'))
    expect(subject.move(from: seed1, to: seed2)).to eq(true)
  end

  it 'provides #pending and #pending_blocks' do
    allow(subject).to receive(:accounts_pending)
      .with(pending_params)
      .and_return(
        NanoRpc::Response.new('blocks' => pending_hash)
      )
    expect(subject.pending(pending_params)).to eq(pending_hash)
    expect(subject.pending_blocks(pending_params)).to eq(pending_hash)
  end
end

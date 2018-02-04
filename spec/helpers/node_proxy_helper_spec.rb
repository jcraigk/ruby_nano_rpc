# frozen_string_literal: true
require 'spec_helper'

class NodeProxyHelperExample
  include Nano::NodeProxyHelper
end

RSpec.describe NodeProxyHelperExample do
  subject { described_class.new }
  let(:pending_hash) { '000BDE' }
  let(:work_params) { { work: '2def', hash: '000DEF' } }
  let(:addr1) { 'nano_address1' }
  let(:seed1) { 'A0BF3C' }
  let(:amount_param) { { amount: 1 } }
  let(:pending_hash_param) { { hash: pending_hash } }

  it 'provides #account_containing_block' do
    allow(subject).to(
      receive(:block_account)
        .with(pending_hash_param)
        .and_return(Nano::Response.new('account' => addr1))
    )
    expect(subject.account_containing_block(pending_hash)).to eq(addr1)
    expect(subject.account_containing_block(pending_hash_param)).to eq(addr1)
  end

  it 'provides #available_nano' do
    allow(subject).to receive(:available_supply).and_return(
      Nano::Response.new('available' => '200')
    )
    expect(subject.available_nano).to eq(200)
  end

  it 'provides #create_wallet' do
    allow(subject).to receive(:wallet_create).and_return(
      Nano::Response.new('wallet' => seed1)
    )
    wallet = subject.create_wallet
    expect(wallet.class).to eq(Nano::Wallet)
    expect(wallet.seed).to eq(seed1)
  end

  it 'provides #pending_exists?' do
    allow(subject).to(
      receive(:pending_exists)
        .with(pending_hash_param)
        .and_return(Nano::Response.new('exists' => '1'))
    )
    expect(subject.pending_exists?(pending_hash)).to eq(true)
    expect(subject.pending_exists?(pending_hash_param)).to eq(true)
  end

  it 'provides #pending_exists?' do
    allow(subject).to(
      receive(:work_validate)
        .with(work_params)
        .and_return(Nano::Response.new('valid' => '1'))
    )
    expect(subject.work_valid?(work_params)).to eq(true)
  end
end

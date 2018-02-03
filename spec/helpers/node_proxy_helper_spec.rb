# frozen_string_literal: true
require 'spec_helper'

class NodeProxyHelperExample
  include Nano::NodeProxyHelper
end

RSpec.describe NodeProxyHelperExample do
  subject { described_class.new }
  let(:rai_amount) { 1_000_000_000_000_000_000_000_000 }
  let(:krai_amount) { 1_000_000_000_000_000_000_000_000_000 }
  let(:mrai_amount) { 1_000_000_000_000_000_000_000_000_000_000 }
  let(:pending_hash) { '000BDE' }
  let(:work_params) { { work: '2def', hash: '000DEF' } }
  let(:addr1) { 'nano_address1' }
  let(:seed1) { 'A0BF3C' }
  let(:amount_param) { { amount: 1 } }
  let(:krai_amount_param) { { amount: krai_amount } }
  let(:mrai_amount_param) { { amount: mrai_amount } }
  let(:rai_amount_param) { { amount: rai_amount } }
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

  it 'provides #available' do
    allow(subject).to receive(:available_supply).and_return(
      Nano::Response.new('available' => '200')
    )
    expect(subject.available).to eq(200)
  end

  it 'provides #create_wallet' do
    allow(subject).to receive(:wallet_create).and_return(
      Nano::Response.new('wallet' => seed1)
    )
    wallet = subject.create_wallet
    expect(wallet.class).to eq(Nano::Wallet)
    expect(wallet.seed).to eq(seed1)
  end

  it 'provides #krai_from' do
    allow(subject).to(
      receive(:krai_from_raw)
        .with(krai_amount_param)
        .and_return(Nano::Response.new('amount' => '1'))
    )
    expect(subject.krai_from(krai_amount)).to eq(1)
    expect(subject.krai_from(krai_amount_param)).to eq(1)
  end

  it 'provides #krai_to' do
    allow(subject).to(
      receive(:krai_to_raw)
        .with(amount_param)
        .and_return(Nano::Response.new('amount' => krai_amount.to_s))
    )
    expect(subject.krai_to(1)).to eq(krai_amount)
    expect(subject.krai_to(amount_param)).to eq(krai_amount)
  end

  it 'provides #mrai_from' do
    allow(subject).to(
      receive(:mrai_from_raw)
        .with(mrai_amount_param)
        .and_return(Nano::Response.new('amount' => '1'))
    )
    expect(subject.mrai_from(mrai_amount)).to eq(1)
    expect(subject.mrai_from(mrai_amount_param)).to eq(1)
  end

  it 'provides #mrai_to' do
    allow(subject).to(
      receive(:mrai_to_raw)
        .with(amount_param)
        .and_return(Nano::Response.new('amount' => mrai_amount.to_s))
    )
    expect(subject.mrai_to(1)).to eq(mrai_amount)
    expect(subject.mrai_to(amount_param)).to eq(mrai_amount)
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

  it 'provides #rai_from' do
    allow(subject).to(
      receive(:rai_from_raw)
        .with(rai_amount_param)
        .and_return(Nano::Response.new('amount' => '1'))
    )
    expect(subject.rai_from(rai_amount)).to eq(1)
    expect(subject.rai_from(rai_amount_param)).to eq(1)
  end

  it 'provides #rai_to' do
    allow(subject).to(
      receive(:rai_to_raw)
        .with(amount_param)
        .and_return(Nano::Response.new('amount' => rai_amount.to_s))
    )
    expect(subject.rai_to(1)).to eq(rai_amount)
    expect(subject.rai_to(amount_param)).to eq(rai_amount)
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

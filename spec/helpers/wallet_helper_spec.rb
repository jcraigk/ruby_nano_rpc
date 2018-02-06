# frozen_string_literal: true
require 'spec_helper'

class WalletHelperExample
  include Nano::WalletHelper
end

RSpec.describe WalletHelperExample do
  subject { described_class.new }
  let(:addr1) { 'nano_address1' }
  let(:addr2) { 'nano_address2' }
  let(:key1) { '34F0A3' }
  let(:work_id) { '432e5cf728c90f4f' }
  let(:add_account_params) { { key: key1, work: true } }
  let(:balance_data) do
    { 'balance' => '100', 'pending' => '5' }
  end
  let(:balances_data) do
    {
      'balances' => {
        addr1 => { 'balance': '100', 'pending': '5' },
        addr2 => { 'balance': '200', 'pending': '10' }
      }
    }
  end
  let(:seed1) { 'CB3004' }
  let(:wallet_data) { { 'some_key' => 1 } }
  let(:block1) { '000D1BA' }
  let(:block2) { 'F2B3809' }
  let(:seed1) { 'A4C1EF' }
  let(:seed2) { 'F9CD82' }
  let(:pending_blocks_params) { { count: 2, threshold: 10, source: seed1 } }
  let(:work1) { '000000' }
  let(:account_param) { { account: addr1 } }
  let(:account_work_params) { { account: addr1, work: work1 } }
  let(:rep_param) { { representative: addr1 } }
  let(:send_nano_params) do
    { from: addr1, to: addr2, amount: 100, work: work1 }
  end
  let(:send_nano_opts) do
    { source: addr1, destination: addr2, amount: 100, work: work1 }
  end
  let(:threshold_param) { { threshold: 10 } }
  let(:create_accounts_params) { { count: 2, work: true } }
  let(:work_data) { { addr1 => work1 } }
  let(:republish_param) { { count: 2 } }
  let(:blocks) { [block1, block2] }
  let(:receive_block_params) { { account: addr1, block: block1 } }
  let(:pending_blocks_data) { { addr1 => block1, addr2 => block2 } }
  let(:frontiers_data) { { addr1 => block1 } }
  let(:addresses) { [addr1, addr2] }
  let(:password_param) { { password: 'pass1' } }
  let(:pending_threshold_param) { { threshold: 10 } }
  let(:pending_threshold_data) { { addr1 => 5, addr2 => 10 } }
  let(:balances_threshold_data) { { addr1 => 100, addr2 => 200 } }

  it 'provides #account_work' do
    allow(subject).to(
      receive(:work_get)
        .with(account_param)
        .and_return(Nano::Response.new('work' => work_id))
    )
    expect(subject.account_work(addr1)).to eq(work_id)
    expect(subject.account_work(account_param)).to eq(work_id)
  end

  it 'provides #accounts' do
    allow(subject).to(
      receive(:account_list)
        .and_return(Nano::Response.new('accounts' => addresses))
    )
    accounts = subject.accounts
    expect(accounts.class).to eq(Nano::Accounts)
    expect(accounts.addresses).to eq(addresses)
  end

  it 'provides #add_key' do
    allow(subject).to(
      receive(:wallet_add)
        .with(add_account_params)
        .and_return(Nano::Response.new('account' => seed1))
    )
    expect(subject.add_key(add_account_params)).to eq(seed1)
  end

  it 'provides #balance' do
    allow(subject).to(
      receive(:wallet_balance_total)
        .and_return(Nano::Response.new(balance_data))
    )
    expect(subject.balance).to eq(100)
  end

  it 'provides #balances' do
    allow(subject).to(
      receive(:wallet_balances)
        .with(threshold_param)
        .and_return(Nano::Response.new(balances_data))
    )
    expect(subject.balances(threshold_param)).to eq(balances_threshold_data)
  end

  it 'provides #begin_payment' do
    allow(subject).to(
      receive(:payment_begin)
        .and_return(Nano::Response.new('account' => addr1))
    )
    expect(subject.begin_payment).to eq(addr1)
  end

  it 'provides #change_password' do
    allow(subject).to(
      receive(:password_change)
        .with(password: 'newpass')
        .and_return(Nano::Response.new('changed' => '1'))
    )
    expect(subject.change_password(new_password: 'newpass')).to eq(true)
    expect(subject.change_password('newpass')).to eq(true)
  end

  it 'provides #change_seed' do
    allow(subject).to(
      receive(:wallet_change_seed)
        .with(seed: seed1)
        .and_return(Nano::Response.new('success' => ''))
    )
    expect(subject.change_seed(new_seed: seed1)).to eq(true)
    expect(subject.change_seed(seed1)).to eq(true)
  end

  it 'provides #contains?' do
    allow(subject).to(
      receive(:wallet_contains)
        .with(account_param)
        .and_return(Nano::Response.new('exists' => '1'))
    )
    expect(subject.contains?(account_param)).to eq(true)
    expect(subject.contains?(addr1)).to eq(true)
  end

  it 'provides #create_account' do
    allow(subject).to(
      receive(:account_create)
        .with(work: true)
        .and_return(Nano::Response.new('account' => addr1))
    )
    account = subject.create_account(work: true)
    expect(account.class).to eq(Nano::Account)
    expect(account.address).to eq(addr1)
  end

  it 'provides #create_accounts' do
    allow(subject).to(
      receive(:accounts_create)
        .with(create_accounts_params)
        .and_return(Nano::Response.new('accounts' => addresses))
    )
    accounts = subject.create_accounts(create_accounts_params)
    expect(accounts.class).to eq(Nano::Accounts)
    expect(accounts.addresses).to eq(addresses)
  end

  it 'provides #destroy' do
    allow(subject).to(
      receive(:wallet_destroy).and_return({})
    )
    expect(subject.destroy).to eq({})
  end

  it 'provides #enter_password' do
    allow(subject).to(
      receive(:password_enter)
        .with(password: 'pass1')
        .and_return(Nano::Response.new('valid' => '1'))
    )
    expect(subject.enter_password(password: 'pass1')).to eq(true)
    expect(subject.enter_password('pass1')).to eq(true)
  end

  it 'provides #export' do
    allow(subject).to(
      receive(:wallet_export)
        .and_return(Nano::Response.new('json' => wallet_data.to_json))
    )
    expect(subject.export).to eq(wallet_data)
    expect(subject.export.some_key).to eq(1)
  end

  it 'provides #frontiers' do
    allow(subject).to(
      receive(:wallet_frontiers)
        .and_return(Nano::Response.new('frontiers' => frontiers_data))
    )
    expect(subject.frontiers).to eq(frontiers_data)
  end

  it 'provides #init_payment' do
    allow(subject).to(
      receive(:payment_init)
        .and_return(Nano::Response.new('status' => 'Ready'))
    )
    expect(subject.init_payment).to eq(true)
  end

  it 'provides #locked?' do
    allow(subject).to(
      receive(:wallet_locked)
        .and_return(Nano::Response.new('locked' => '1'))
    )
    expect(subject.locked?).to eq(true)
  end

  it 'provides #move_accounts' do
    allow(subject).to receive(:seed).and_return(seed1)
    allow(subject).to(
      receive(:account_move)
        .with(wallet: seed2, source: seed1, accounts: addresses)
        .and_return(Nano::Response.new('moved' => '1'))
    )
    expect(subject.move_accounts(to: seed2, accounts: addresses)).to eq(true)
  end

  it 'provides #password_valid?' do
    allow(subject).to(
      receive(:password_valid)
        .with(password_param)
        .and_return(Nano::Response.new('valid' => '1'))
    )
    expect(subject.password_valid?(password_param)).to eq(true)
    expect(subject.password_valid?('pass1')).to eq(true)
  end

  it 'provides #pending_balance and #balance_pending' do
    allow(subject).to(
      receive(:wallet_balance_total)
        .and_return(Nano::Response.new(balance_data))
    )
    expect(subject.pending_balance).to eq(5)
    expect(subject.balance_pending).to eq(5)
  end

  it 'provides #pending_balances and #balances_pending' do
    allow(subject).to(
      receive(:wallet_balances)
        .with(pending_threshold_param)
        .and_return(Nano::Response.new(balances_data))
    )
    expect(
      subject.pending_balances(pending_threshold_param)
    ).to eq(pending_threshold_data)
    expect(
      subject.balances_pending(pending_threshold_param)
    ).to eq(pending_threshold_data)
  end

  it 'provides #pending_blocks and #blocks_pending' do
    allow(subject).to(
      receive(:wallet_pending)
        .with(pending_blocks_params)
        .and_return(Nano::Response.new('blocks' => pending_blocks_data))
    )
    expect(
      subject.pending_blocks(pending_blocks_params)
    ).to eq(pending_blocks_data)
    expect(
      subject.blocks_pending(pending_blocks_params)
    ).to eq(pending_blocks_data)
  end

  it 'provides #receive_block' do
    allow(subject).to(
      receive(:receive)
        .with(receive_block_params)
        .and_return(Nano::Response.new('block' => block2))
    )
    expect(subject.receive_block(receive_block_params)).to eq(block2)
  end

  it 'provides #remove_account' do
    allow(subject).to(
      receive(:account_remove)
        .with(account_param)
        .and_return(Nano::Response.new('removed' => '1'))
    )
    expect(subject.remove_account(account_param)).to eq(true)
    expect(subject.remove_account(addr1)).to eq(true)
  end

  it 'provides #representative' do
    allow(subject).to(
      receive(:wallet_representative)
        .and_return(Nano::Response.new('representative' => addr1))
    )
    expect(subject.representative).to eq(addr1)
  end

  it 'provides #republish' do
    allow(subject).to(
      receive(:wallet_republish)
        .with(republish_param)
        .and_return(Nano::Response.new('blocks' => blocks))
    )
    expect(subject.republish(republish_param)).to eq(blocks)
    expect(subject.republish(2)).to eq(blocks)
  end

  it 'provides #account_work_set and #set_account_work' do
    allow(subject).to(
      receive(:work_set)
        .with(account_work_params)
        .and_return(Nano::Response.new('success' => ''))
    )
    expect(subject.account_work_set(account_work_params)).to eq(true)
    expect(subject.set_account_work(account_work_params)).to eq(true)
  end

  it 'provides #representative_set and #set_representative' do
    allow(subject).to(
      receive(:wallet_representative_set)
        .with(rep_param)
        .and_return(Nano::Response.new('set' => '1'))
    )
    expect(subject.representative_set(rep_param)).to eq(true)
    expect(subject.representative_set(addr1)).to eq(true)
    expect(subject.set_representative(addr1)).to eq(true)
  end

  it 'provides #send_nano and #send_transaction' do
    allow(subject).to(
      receive(:send_currency)
        .with(send_nano_opts)
        .and_return(Nano::Response.new('block' => block1))
    )
    expect(subject.send_nano(send_nano_params)).to eq(block1)
    expect(subject.send_transaction(send_nano_params)).to eq(block1)
  end

  it 'provides #work' do
    allow(subject).to(
      receive(:wallet_work_get)
        .and_return(Nano::Response.new('works' => work_data))
    )
    expect(subject.work).to eq(work_data)
  end
end

# frozen_string_literal: true

require 'spec_helper'

class WalletHelper
  attr_reader :client

  include NanoRpc::WalletHelper
end

RSpec.describe WalletHelper do
  subject(:wallet) { NanoRpc::Wallet.new('abcd') }

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
  let(:seed) { 'ABCDEF' }
  let(:wallet_data) { { 'some_key' => 1 } }
  let(:block1) { '000D1BA' }
  let(:block2) { 'F2B3809' }
  let(:wallet_id1) { 'A4C1EF' }
  let(:wallet_id2) { 'F9CD82' }
  let(:wallet_pending_params) do
    {
      count: 2,
      threshold: 10,
      source: wallet_id1,
      include_active: true
    }
  end
  let(:work1) { '000000' }
  let(:account_param) { { account: addr1 } }
  let(:account_work_params) { { account: addr1, work: work1 } }
  let(:rep_param) { { representative: addr1 } }
  let(:send_nano_params) do
    { from: addr1, to: addr2, amount: 100, id: 1, work: work1 }
  end
  let(:send_nano_objects) do
    {
      from: NanoRpc::Account.new(addr1),
      to: NanoRpc::Account.new(addr2),
      amount: 100,
      id: 1,
      work: work1
    }
  end
  let(:send_nano_opts) do
    { source: addr1, destination: addr2, amount: 100, id: 1, work: work1 }
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

  describe '#' do
    before do
      allow(wallet).to(
        receive(:work_get)
          .with(account_param)
          .and_return(NanoRpc::Response.new('work' => work_id))
      )
    end

    it 'returns exepcted value' do
      expect(wallet.account_work(account_param)).to eq(work_id)
    end
  end

  describe '#accounts' do
    let(:accounts) { wallet.accounts }

    before do
      allow(wallet).to(
        receive(:account_list)
          .and_return(NanoRpc::Response.new('accounts' => addresses))
      )
    end

    it 'provides expected class' do
      expect(accounts.class).to eq(NanoRpc::Accounts)
    end

    it 'provides expected value' do
      expect(accounts.addresses).to eq(addresses)
    end
  end

  describe '#add_key' do
    before do
      allow(wallet).to(
        receive(:wallet_add)
          .with(add_account_params)
          .and_return(NanoRpc::Response.new('account' => wallet_id1))
      )
    end

    it 'returns expected value' do
      expect(wallet.add_key(add_account_params)).to eq(wallet_id1)
    end
  end

  describe '#add_watch' do
    before do
      allow(wallet).to(
        receive(:wallet_add_watch)
          .with(accounts: addresses)
          .and_return(NanoRpc::Response.new('success' => ''))
      )
    end

    it 'returns expected value' do
      expect(wallet.add_watch(accounts: addresses)).to eq(true)
    end
  end

  it 'provides #balance' do
    allow(wallet).to(
      receive(:wallet_info)
        .and_return(NanoRpc::Response.new(balance_data))
    )
    expect(wallet.balance).to eq(100)
  end

  describe '#balances' do
    before do
      allow(wallet).to(
        receive(:wallet_balances)
          .with(threshold_param)
          .and_return(NanoRpc::Response.new(balances_data))
      )
    end

    it 'returns expected value' do
      expect(wallet.balances(threshold_param)).to eq(balances_threshold_data)
    end
  end

  it 'provides #begin_payment' do
    allow(wallet).to(
      receive(:payment_begin)
        .and_return(NanoRpc::Response.new('account' => addr1))
    )
    expect(wallet.begin_payment).to eq(addr1)
  end

  describe '#change_password' do
    before do
      allow(wallet).to(
        receive(:password_change)
          .with(password: 'newpass')
          .and_return(NanoRpc::Response.new('changed' => '1'))
      )
    end

    it 'returns expected value ' do
      expect(wallet.change_password(new_password: 'newpass')).to eq(true)
    end
  end

  describe '#change_seed' do
    before do
      allow(wallet).to(
        receive(:wallet_change_seed)
          .with(seed: 'newseed', count: 10)
          .and_return(NanoRpc::Response.new('success' => ''))
      )
    end

    it 'returns expected value' do
      expect(wallet.change_seed(new_seed: 'newseed', count: 10)).to eq(true)
    end
  end

  describe '#contains?' do
    before do
      allow(wallet).to(
        receive(:wallet_contains)
          .with(account_param)
          .and_return(NanoRpc::Response.new('exists' => '1'))
      )
    end

    it 'returns expected value ' do
      expect(wallet.contains?(account_param)).to eq(true)
    end
  end

  describe '#create_account' do
    let(:account) { wallet.create_account(work: true) }

    before do
      allow(wallet).to(
        receive(:account_create)
          .with(work: true)
          .and_return(NanoRpc::Response.new('account' => addr1))
      )
    end

    it 'provides expected class' do
      expect(account.class).to eq(NanoRpc::Account)
    end

    it 'provides expected value' do
      expect(account.address).to eq(addr1)
    end
  end

  describe '#create_accounts' do
    let(:accounts) { wallet.create_accounts(create_accounts_params) }

    before do
      allow(wallet).to(
        receive(:accounts_create)
          .with(create_accounts_params)
          .and_return(NanoRpc::Response.new('accounts' => addresses))
      )
    end

    it 'provides expected class' do
      expect(accounts.class).to eq(NanoRpc::Accounts)
    end

    it 'provides expected value' do
      expect(accounts.addresses).to eq(addresses)
    end
  end

  it 'provides #destroy' do
    allow(wallet).to(
      receive(:wallet_destroy)
        .and_return(NanoRpc::Response.new('destroyed' => '1'))
    )
    expect(wallet.destroy).to eq(true)
  end

  describe '#enter_password and #unlock' do
    before do
      allow(wallet).to(
        receive(:password_enter)
          .with(password: 'pass1')
          .and_return(NanoRpc::Response.new('valid' => '1'))
      )
    end

    it 'provides #enter_password' do
      expect(wallet.enter_password(password: 'pass1')).to eq(true)
    end

    it 'provides #unlock' do
      expect(wallet.unlock(password: 'pass1')).to eq(true)
    end
  end

  describe 'export' do
    before do
      allow(wallet).to(
        receive(:wallet_export)
          .and_return(NanoRpc::Response.new('json' => wallet_data.to_json))
      )
    end

    it 'provides #export' do
      expect(wallet.export).to eq(wallet_data)
    end

    it 'provides #export.some_key' do
      expect(wallet.export.some_key).to eq(1)
    end
  end

  it 'provides #frontiers' do
    allow(wallet).to(
      receive(:wallet_frontiers)
        .and_return(NanoRpc::Response.new('frontiers' => frontiers_data))
    )
    expect(wallet.frontiers).to eq(frontiers_data)
  end

  describe '#history' do
    before do
      allow(wallet).to(
        receive(:wallet_history)
          .with(modified_since: 1_550_461_032)
          .and_return(NanoRpc::Response.new('history' => []))
      )
    end

    it 'returns expected value' do
      expect(wallet.history(modified_since: 1_550_461_032)).to eq([])
    end
  end

  it 'provides #init_payment' do
    allow(wallet).to(
      receive(:payment_init)
        .and_return(NanoRpc::Response.new('status' => 'Ready'))
    )
    expect(wallet.init_payment).to eq(true)
  end

  describe '#ledger' do
    before do
      allow(wallet).to(
        receive(:wallet_ledger)
          .and_return(
            NanoRpc::Response.new('accounts' => { 'abc' => {} })
          )
      )
    end

    it 'returns expected value' do
      expect(wallet.ledger).to eq('abc' => {})
    end
  end

  it 'provides #locked?' do
    allow(wallet).to(
      receive(:wallet_locked)
        .and_return(NanoRpc::Response.new('locked' => '1'))
    )
    expect(wallet.locked?).to eq(true)
  end

  describe '#move_accounts' do
    before do
      allow(wallet).to receive(:id).and_return(wallet_id1)
      allow(wallet).to(
        receive(:account_move)
          .with(wallet: wallet_id2, source: wallet_id1, accounts: addresses)
          .and_return(NanoRpc::Response.new('moved' => '1'))
      )
    end

    it 'moves the accounts' do
      expect(
        wallet.move_accounts(to: wallet_id2, accounts: addresses)
      ).to eq(true)
    end
  end

  describe '#password_valid?' do
    before do
      allow(wallet).to(
        receive(:password_valid)
          .with(password_param)
          .and_return(NanoRpc::Response.new('valid' => '1'))
      )
    end

    it 'returns expected value' do
      expect(wallet.password_valid?(password_param)).to eq(true)
    end
  end

  describe '#pending_balance and #balance_pending' do
    before do
      allow(wallet).to(
        receive(:wallet_info)
          .and_return(NanoRpc::Response.new(balance_data))
      )
    end

    it 'provides #pending_balance' do
      expect(wallet.pending_balance).to eq(5)
    end

    it 'provides #balance_pending' do
      expect(wallet.balance_pending).to eq(5)
    end
  end

  describe 'pending balances' do
    before do
      allow(wallet).to(
        receive(:wallet_balances)
          .with(pending_threshold_param)
          .and_return(NanoRpc::Response.new(balances_data))
      )
    end

    it 'provides #pending_balances and #balances_pending' do
      expect(
        wallet.pending_balances(pending_threshold_param)
      ).to eq(pending_threshold_data)
    end

    it 'provides #pending_balances' do
      expect(
        wallet.balances_pending(pending_threshold_param)
      ).to eq(pending_threshold_data)
    end
  end

  describe 'pending blocks' do
    before do
      allow(wallet).to(
        receive(:wallet_pending)
          .with(wallet_pending_params)
          .and_return(NanoRpc::Response.new('blocks' => pending_blocks_data))
      )
    end

    describe '#pending_blocks and #blocks_pending' do
      it 'provides #pending_blocks' do
        expect(
          wallet.pending_blocks(wallet_pending_params)
        ).to eq(pending_blocks_data)
      end

      it 'provides #blocks_pending' do
        expect(
          wallet.blocks_pending(wallet_pending_params)
        ).to eq(pending_blocks_data)
      end
    end
  end

  describe '#receive_block' do
    before do
      allow(wallet).to(
        receive(:receive)
          .with(receive_block_params)
          .and_return(NanoRpc::Response.new('block' => block2))
      )
    end

    it 'returns expected value' do
      expect(wallet.receive_block(receive_block_params)).to eq(block2)
    end
  end

  describe '#remove_account' do
    before do
      allow(wallet).to(
        receive(:account_remove)
          .with(account_param)
          .and_return(NanoRpc::Response.new('removed' => '1'))
      )
    end

    it 'returns expected value' do
      expect(wallet.remove_account(account_param)).to eq(true)
    end
  end

  describe '#representative' do
    before do
      allow(wallet).to(
        receive(:wallet_representative)
          .and_return(NanoRpc::Response.new('representative' => addr1))
      )
    end

    it 'returns expected value' do
      expect(wallet.representative).to eq(addr1)
    end
  end

  describe '#republish' do
    before do
      allow(wallet).to(
        receive(:wallet_republish)
          .with(republish_param)
          .and_return(NanoRpc::Response.new('blocks' => blocks))
      )
    end

    it 'returns expected value' do
      expect(wallet.republish(republish_param)).to eq(blocks)
    end
  end

  describe '#account_work_set and #set_account_work' do
    before do
      allow(wallet).to(
        receive(:work_set)
          .with(account_work_params)
          .and_return(NanoRpc::Response.new('success' => ''))
      )
    end

    it 'provides #account_work_set' do
      expect(wallet.account_work_set(account_work_params)).to eq(true)
    end

    it 'provides #set_account_work' do
      expect(wallet.set_account_work(account_work_params)).to eq(true)
    end
  end

  describe '#representative_set and #set_representative' do
    before do
      allow(wallet).to(
        receive(:wallet_representative_set)
          .with(rep_param)
          .and_return(NanoRpc::Response.new('set' => '1'))
      )
    end

    it 'provides #representative_set' do
      expect(wallet.representative_set(rep_param)).to eq(true)
    end

    it 'provides #set_representative' do
      expect(wallet.set_representative(rep_param)).to eq(true)
    end
  end

  describe '#send_nano and #send_transaction' do
    before do
      allow(wallet).to(
        receive(:send_currency)
          .with(send_nano_opts)
          .and_return(NanoRpc::Response.new('block' => block1))
      )
    end

    it 'provides #send_nano accepting params' do
      expect(wallet.send_nano(send_nano_params)).to eq(block1)
    end

    it 'provides #send_nano accepting objects' do
      expect(wallet.send_nano(send_nano_objects)).to eq(block1)
    end

    it 'provides #send_transaction accepting params' do
      expect(wallet.send_transaction(send_nano_params)).to eq(block1)
    end
  end

  it 'provides #work' do
    allow(wallet).to(
      receive(:wallet_work_get)
        .and_return(NanoRpc::Response.new('works' => work_data))
    )
    expect(wallet.work).to eq(work_data)
  end
end

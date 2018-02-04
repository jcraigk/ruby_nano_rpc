# frozen_string_literal: true
module Nano::WalletProxyHelper
  include Nano::ApplicationHelper

  def account_work(opts)
    work_get(opts_account(opts)).work
  end

  def add_key(key:, work: true)
    wallet_add(key: key, work: work).account
  end

  def balance
    wallet_balance_total.balance
  end

  def balances(threshold: nil)
    wallet_balances(threshold: threshold)
      .balances
      .each_with_object({}) do |(k, v), hash|
        hash[k] = v['balance'].to_i
      end
  end

  def begin_payment
    payment_begin.account
  end

  def change_password(opts)
    password_change(
      password: opts_pluck(opts, :new_password)
    ).changed == 1
  end

  def change_seed(opts)
    wallet_change_seed(
      seed: opts_pluck(opts, :new_seed)
    ).success == ''
  end

  def contains?(opts)
    wallet_contains(opts_account(opts)).exists == 1
  end

  def create_account(work: true)
    Nano::Account.new(account_create(work: work).account)
  end

  def create_accounts(count:, work: true)
    Nano::Accounts.new(accounts_create(count: count, work: work).accounts)
  end

  def destroy
    wallet_destroy
  end

  def enter_password(opts)
    password_enter(
      password: opts_pluck(opts, :password)
    ).valid == 1
  end

  def export
    Nano::Response.new(JSON[wallet_export.json])
  end

  def frontiers
    wallet_frontiers.frontiers
  end

  def init_payment
    payment_init.status == 'Ready'
  end

  def locked?
    wallet_locked.locked == 1
  end

  def move_accounts(to:, accounts:)
    account_move(
      wallet: to,
      source: seed,
      accounts: accounts
    ).moved == 1
  end

  def password_valid?(opts)
    password_valid(
      password: opts_pluck(opts, :password)
    ).valid == 1
  end

  def pending_balance
    wallet_balance_total.pending
  end
  alias balance_pending pending_balance

  def pending_balances(threshold: nil)
    wallet_balances(threshold: threshold)
      .balances
      .each_with_object({}) do |(k, v), hash|
        hash[k] = v['pending'].to_i
      end
  end
  alias balances_pending pending_balances

  def pending_blocks(count:, threshold: nil, source: nil)
    wallet_pending(
      count: count,
      threshold: threshold,
      source: source
    ).blocks
  end
  alias blocks_pending pending_blocks

  def receive_block(account:, block:)
    receive(account: account, block: block).block
  end

  def remove_account(opts)
    account_remove(opts_account(opts)).removed == 1
  end

  def representative
    wallet_representative.representative
  end

  def republish(opts)
    wallet_republish(count: opts_pluck(opts, :count)).blocks
  end

  def account_work_set(account:, work:)
    work_set(account: account, work: work).success == ''
  end
  alias set_account_work account_work_set

  def representative_set(opts)
    wallet_representative_set(
      representative: opts_pluck(opts, :representative)
    ).set == 1
  end
  alias set_representative representative_set

  def send_nano(from:, to:, amount:, work: nil)
    send_currency(
      source: from,
      destination: to,
      amount: amount,
      work: work
    ).block
  end
  alias send_transaction send_nano

  def work
    wallet_work_get.works
  end

  private

  def opts_account(opts)
    { account: opts_pluck(opts, :account) }
  end
end

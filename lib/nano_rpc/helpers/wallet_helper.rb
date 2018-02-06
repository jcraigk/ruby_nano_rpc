# frozen_string_literal: true
module Nano::WalletHelper
  include Nano::ApplicationHelper

  def account_work(*args)
    work_get(pluck_argument(args, :account)).work
  end

  def accounts
    return [] unless account_list.accounts.size.positive?
    Nano::Accounts.new(account_list.accounts)
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

  def change_password(*args)
    password_change(
      pluck_argument(args, :new_password, :password)
    ).changed == 1
  end

  def change_seed(*args)
    wallet_change_seed(
      pluck_argument(args, :new_seed, :seed)
    ).success == ''
  end

  def contains?(*args)
    wallet_contains(pluck_argument(args, :account)).exists == 1
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

  def enter_password(*args)
    password_enter(pluck_argument(args, :password)).valid == 1
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
      wallet: object_to_value(to),
      source: seed,
      accounts: object_to_value(accounts)
    ).moved == 1
  end

  def password_valid?(*args)
    password_valid(pluck_argument(args, :password)).valid == 1
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
    receive(
      account: object_to_value(account),
      block: block
    ).block
  end

  def remove_account(*args)
    account_remove(pluck_argument(args, :account)).removed == 1
  end

  def representative
    wallet_representative.representative
  end

  def republish(*args)
    wallet_republish(pluck_argument(args, :count)).blocks
  end

  def account_work_set(account:, work:)
    work_set(
      account: object_to_value(account),
      work: work
    ).success == ''
  end
  alias set_account_work account_work_set

  def representative_set(*args)
    wallet_representative_set(
      pluck_argument(args, :representative)
    ).set == 1
  end
  alias set_representative representative_set

  def send_nano(from:, to:, amount:, work: nil)
    send_currency(
      source: object_to_value(from),
      destination: object_to_value(to),
      amount: amount,
      work: work
    ).block
  end
  alias send_transaction send_nano

  def work
    wallet_work_get.works
  end
end

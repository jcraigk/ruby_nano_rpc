# frozen_string_literal: true
module NanoRpc::WalletHelper
  include NanoRpc::ApplicationHelper

  def account_work(account:)
    work_get(account: account).work
  end

  def accounts
    return [] unless account_list.accounts.size.positive?
    NanoRpc::Accounts.new(account_list.accounts, node: node)
  end

  def add_key(key:, work: true)
    wallet_add(key: key, work: work).account
  end

  def add_watch(accounts:)
    wallet_add_watch(accounts: accounts).success == ''
  end

  def balance
    wallet_info.balance
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

  def change_password(new_password:)
    password_change(password: new_password).changed == 1
  end

  def change_seed(new_seed:, count: 0)
    wallet_change_seed(seed: new_seed, count: count).success == ''
  end

  def contains?(account:)
    wallet_contains(account: account).exists == 1
  end

  def create_account(work: true)
    address = account_create(work: work).account
    NanoRpc::Account.new(address, node: node)
  end

  def create_accounts(count:, work: true)
    addresses = accounts_create(count: count, work: work).accounts
    NanoRpc::Accounts.new(addresses, node: node)
  end

  def destroy
    wallet_destroy.destroyed == 1
  end

  def enter_password(password:)
    password_enter(password: password).valid == 1
  end
  alias unlock enter_password

  def export
    NanoRpc::Response.new(JSON[wallet_export.json])
  end

  def frontiers
    wallet_frontiers.frontiers
  end

  def history(modified_since: 0)
    wallet_history(modified_since: modified_since).history
  end

  def init_payment
    payment_init.status == 'Ready'
  end

  def ledger
    wallet_ledger.accounts
  end

  def locked?
    wallet_locked.locked == 1
  end

  def move_accounts(to:, accounts:)
    account_move(wallet: to, source: id, accounts: accounts).moved == 1
  end

  def password_valid?(password:)
    password_valid(password: password).valid == 1
  end

  def pending_balance
    wallet_info.pending
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

  def pending_blocks(count:, threshold: nil, source: nil, include_active: nil)
    wallet_pending(
      count: count,
      threshold: threshold,
      source: source,
      include_active: include_active
    ).blocks
  end
  alias blocks_pending pending_blocks

  def receive_block(account:, block:)
    receive(
      account: account,
      block: block
    ).block
  end

  def remove_account(account:)
    account_remove(account: account).removed == 1
  end

  def representative
    wallet_representative.representative
  end

  def republish(count:)
    wallet_republish(count: count).blocks
  end

  def account_work_set(account:, work:)
    work_set(account: account, work: work).success == ''
  end
  alias set_account_work account_work_set

  def representative_set(representative:)
    wallet_representative_set(representative: representative).set == 1
  end
  alias set_representative representative_set

  def send_nano(from:, to:, amount:, id: nil, work: nil)
    from = from.respond_to?(:address) ? from.address : from
    to = to.respond_to?(:address) ? to.address : to
    send_currency(
      source: from,
      destination: to,
      amount: amount,
      id: id,
      work: work
    ).block
  end
  alias send_transaction send_nano

  def work
    wallet_work_get.works
  end
end

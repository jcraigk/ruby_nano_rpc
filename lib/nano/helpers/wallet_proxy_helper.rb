# frozen_string_literal: true
module Nano::WalletProxyHelper
  def account_work(account:)
    work_get.work(account: account).work
  end

  def add(key:, work: nil)
    wallet_add(key: key, work: work).account
  end

  def balance
    wallet_balance_total.balance
  end

  def balances(threshold: nil)
    wallet_balances(threshold: threshold).balances
  end

  def begin_payment
    payment_begin.account
  end

  def change_password(new_password:)
    password_change(password: new_password).changed == 1
  end

  def change_seed(new_seed:)
    wallet_change_seed(seed: new_seed)[:success] == ''
  end

  def contains?(account:)
    wallet_contains(account: account).exists == 1
  end

  def create
    wallet_create.wallet
  end

  def destroy
    wallet_destroy
  end

  def enter_password(password)
    password_enter(password: password).valid == 1
  end

  def export
    JSON[wallet_export.json]
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

  def password_valid?(password:)
    password_valid(password: password).valid == 1
  end

  def pending_balance
    wallet_balance_total.pending
  end

  def pending_blocks(count:, threshold: nil, source: nil)
    wallet_pending(count: count, threshold: threshold, source: source).blocks
  end

  def receive_block(account:, block:)
    receive.block(account: account, block: block).block
  end

  def representative
    wallet_representative.representative
  end

  def republish(count:)
    wallet_republish(count: count).blocks
  end

  def account_work_set(account:, work:)
    work_set(account: account, work: work).work[:success] == ''
  end
  alias set_account_work account_work_set

  def representative_set(representative:)
    wallet_representative_set(representative: representative).set == 1
  end
  alias set_representative representative_set

  def send_tx(source:, destination:, amount:)
    rai_send(source: source, destination: destination, amount: amount).block
  end
  alias send_transaction send_tx

  def work
    wallet_work_get.works
  end
end

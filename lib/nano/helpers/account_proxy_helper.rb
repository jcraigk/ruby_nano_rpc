# frozen_string_literal: true
module Nano::AccountProxyHelper
  def balance
    account_balance.balance
  end

  def block_count
    account_block_count.block_count
  end

  def create(wallet:, work:)
    account_create(wallet: wallet, work: work).account
  end

  def history(count:)
    account_history(count: count).history
  end

  def info
    account_info
  end

  def key
    account_key.key
  end

  def list
    account_list.accounts
  end

  def move(wallet:, source:, accounts:)
    account_move(wallet: wallet, source: source, accounts: accounts).moved == 1
  end

  def wallet_work(wallet:)
    work_get(wallet: wallet).work
  end

  def wallet_work_set(wallet:, work:)
    work_set(wallet: wallet, work: work).work[:success] == ''
  end

  def pending_balance
    account_balance.pending
  end
  alias balance_pending pending_balance

  def pending_blocks(count:, threshold: nil, exists: nil)
    pending(count: count, threshold: threshold, exists: exists).locks
  end
  alias blocks_pending pending_blocks

  def remove(wallet:)
    account_remove(wallet: wallet).removed == 1
  end

  def representative
    account_representative.representative
  end

  def representative_set(wallet:, representative:)
    account_representative_set(
      wallet: wallet, representative: representative
    ).set == 1
  end

  def weight
    account_weight.weight
  end
end

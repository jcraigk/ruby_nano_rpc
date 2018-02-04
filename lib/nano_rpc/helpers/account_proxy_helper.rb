# frozen_string_literal: true
module Nano::AccountProxyHelper
  include Nano::ApplicationHelper

  def balance
    account_balance.balance
  end

  def block_count
    account_block_count.block_count
  end

  def history(opts)
    account_history(
      count: opts_pluck(opts, :count)
    ).history
  end

  def info
    account_info
  end

  def key
    account_key['key']
  end

  def move(from:, to:)
    account_move(
      wallet: wallet_seed(to),
      source: wallet_seed(from),
      accounts: [address]
    ).moved == 1
  end

  def wallet_work_set(wallet:, work:)
    work_set(
      wallet: wallet_seed(wallet),
      work: work
    ).success == ''
  end

  def pending_balance
    account_balance.pending
  end
  alias balance_pending pending_balance

  def pending_blocks(count:, threshold: nil, source: nil)
    pending(
      count: count,
      threshold: threshold,
      source: source
    ).blocks
  end
  alias blocks_pending pending_blocks

  def remove(opts)
    account_remove(
      wallet: wallet_seed(opts_pluck(opts, :wallet))
    ).removed == 1
  end

  def representative
    account_representative.representative
  end

  def representative_set(wallet:, representative:)
    account_representative_set(
      wallet: wallet_seed(wallet),
      representative: representative
    ).set == 1
  end

  def weight
    account_weight.weight
  end
end

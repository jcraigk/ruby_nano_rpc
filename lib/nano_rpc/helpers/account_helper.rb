# frozen_string_literal: true

module NanoRpc
  # Methods to support NanoRpc::Account
  module AccountHelper
    include NanoRpc::ApplicationHelper

    def balance
      account_balance.balance
    end

    def block_count
      account_block_count.block_count
    end

    def history(count:)
      account_history(count: count).history
    end

    def info
      account_info
    end

    def key
      account_key['key']
    end

    def move(from:, to:)
      account_move(
        source: from,
        wallet: to,
        accounts: [address]
      ).moved == 1
    end

    def wallet_work_set(wallet:, work:)
      work_set(wallet: wallet, work: work).success == ''
    end

    def pending_balance
      account_balance.pending
    end
    alias balance_pending pending_balance

    def pending_blocks(count: 100, threshold: nil, source: nil)
      pending(
        count: count,
        threshold: threshold,
        source: source
      ).blocks
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
        wallet: wallet,
        representative: representative
      ).set == 1
    end

    def valid?
      validate_account_number.valid == 1
    end

    def weight
      account_weight.weight
    end
  end
end

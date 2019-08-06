# frozen_string_literal: true

module NanoRpc
  # Methods to support NanoRpc::Accounts
  module AccountsHelper
    include NanoRpc::ApplicationHelper

    def balances
      accounts_balances
        .balances
        .each_with_object({}) do |(k, v), hash|
        hash[k] = v['balance']
      end
    end

    def pending_balances
      accounts_balances
        .balances
        .each_with_object({}) do |(k, v), hash|
        hash[k] = v['pending']
      end
    end
    alias balances_pending pending_balances

    def frontiers
      accounts_frontiers.frontiers
    end

    def move(from:, to:)
      account_move(source: from, wallet: to).moved == 1
    end

    def pending(count:, threshold: nil, source: nil, include_active: nil)
      accounts_pending(
        count: count,
        threshold: threshold,
        source: source,
        include_active: include_active
      ).blocks
    end
    alias pending_blocks pending

    # Array-like access for NanoRpc::Account
    def [](idx)
      return unless addresses[idx]

      to_a[idx]
    end

    def <<(val)
      @to_a = nil
      @addresses << val
    end

    def each(&_block)
      to_a.each { |account| yield account }
    end

    def to_a
      @to_a ||=
        addresses.map do |address|
          NanoRpc::Account.new(address, node: node)
        end
    end
  end
end

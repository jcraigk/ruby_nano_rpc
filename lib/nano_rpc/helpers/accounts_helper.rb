# frozen_string_literal: true
module Nano::AccountsHelper
  include Nano::ApplicationHelper

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

  def pending(count:, threshold: nil, source: nil)
    accounts_pending(
      count: count,
      threshold: threshold,
      source: source
    ).blocks
  end
  alias pending_blocks pending

  # Array-like access for Nano::Account
  def [](idx)
    return unless @addresses[idx]
    @account_objects ||= []
    @account_objects[idx] ||= Nano::Account.new(@addresses[idx], client: client)
  end

  def <<(val)
    @addresses << val
  end

  def each(&_block)
    @addresses.each do |address|
      yield Nano::Account.new(address, client: client)
    end
  end

  def first
    self[0]
  end

  def second
    self[1]
  end

  def third
    self[2]
  end

  def last
    self[-1]
  end

  def size
    addresses.size
  end
end

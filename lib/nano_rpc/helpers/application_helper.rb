# frozen_string_literal: true
module Nano::ApplicationHelper
  private

  def opts_pluck(opts, key)
    opts.is_a?(Hash) ? opts[key] : opts
  end

  def wallet_seed(wallet)
    wallet.is_a?(Nano::Wallet) ? wallet.seed : wallet
  end

  def account_address(account)
    account.is_a?(Nano::Account) ? account.address : account
  end

  def accounts_addresses(accounts)
    accounts.is_a?(Nano::Accounts) ? accounts.addresses : accounts
  end

  def inspect_prefix
    "#<#{self.class}:#{format('0x00%x', object_id << 1)}"
  end
end

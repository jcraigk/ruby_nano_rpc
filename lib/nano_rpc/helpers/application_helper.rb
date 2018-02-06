# frozen_string_literal: true
module Nano::ApplicationHelper
  private

  def pluck_argument(args, key)
    arg = args.first
    arg.is_a?(Hash) ? arg[key] : arg
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

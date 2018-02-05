# frozen_string_literal: true
module Nano::NodeProxyHelper
  include Nano::ApplicationHelper

  def account_containing_block(opts)
    block_account(opts_hash(opts)).account
  end

  def total_supply
    available_supply.available
  end

  def create_wallet
    Nano::Wallet.new(wallet_create.wallet)
  end

  def pending_exists?(opts)
    pending_exists(opts_hash(opts)).exists == 1
  end

  def work_valid?(work:, hash:)
    work_validate(work: work, hash: hash).valid == 1
  end

  private

  def opts_hash(opts)
    { hash: opts_pluck(opts, :hash) }
  end
end

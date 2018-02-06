# frozen_string_literal: true
module Nano::NodeHelper
  include Nano::ApplicationHelper

  def account_containing_block(*args)
    block_account(pluck_argument(args, :hash)).account
  end

  def create_wallet
    Nano::Wallet.new(wallet_create.wallet)
  end

  def num_frontiers
    frontier_count['count']
  end

  def pending_exists?(*args)
    pending_exists(pluck_argument(args, :hash)).exists == 1
  end

  def total_supply
    available_supply.available
  end

  def work_valid?(work:, hash:)
    work_validate(work: work, hash: hash).valid == 1
  end
end

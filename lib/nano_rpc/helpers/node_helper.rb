# frozen_string_literal: true
module Nano::NodeHelper
  include Nano::ApplicationHelper

  def account_containing_block(*args)
    block_account(pluck_argument(args, :hash)).account
  end

  def create_wallet
    Nano::Wallet.new(wallet_create.wallet)
  end

  def knano_from_raw(*args)
    krai_from_raw(pluck_argument(args, :amount)).amount
  end

  def knano_to_raw(*args)
    krai_to_raw(pluck_argument(args, :amount)).amount
  end

  def mnano_from_raw(*args)
    mrai_from_raw(pluck_argument(args, :amount)).amount
  end

  def mnano_to_raw(*args)
    mrai_to_raw(pluck_argument(args, :amount)).amount
  end

  def nano_from_raw(*args)
    rai_from_raw(pluck_argument(args, :amount)).amount
  end

  def nano_to_raw(*args)
    rai_to_raw(pluck_argument(args, :amount)).amount
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

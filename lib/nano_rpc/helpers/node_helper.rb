# frozen_string_literal: true
module Nano::NodeHelper
  include Nano::ApplicationHelper

  def account_containing_block(hash:)
    block_account(hash: hash).account
  end

  def create_wallet
    Nano::Wallet.new(wallet_create.wallet, client: client)
  end

  def knano_from_raw(amount:)
    krai_from_raw(amount: amount).amount
  end

  def knano_to_raw(amount:)
    krai_to_raw(amount: amount).amount
  end

  def mnano_from_raw(amount:)
    mrai_from_raw(amount: amount).amount
  end

  def mnano_to_raw(amount:)
    mrai_to_raw(amount: amount).amount
  end

  def nano_from_raw(amount:)
    rai_from_raw(amount: amount).amount
  end

  def nano_to_raw(amount:)
    rai_to_raw(amount: amount).amount
  end

  def num_frontiers
    frontier_count['count']
  end

  def pending_exists?(hash:)
    pending_exists(hash: hash).exists == 1
  end

  def total_supply
    available_supply.available
  end

  def work_valid?(work:, hash:)
    work_validate(work: work, hash: hash).valid == 1
  end
end

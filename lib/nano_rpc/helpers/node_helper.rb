# frozen_string_literal: true
module NanoRpc::NodeHelper
  include NanoRpc::ApplicationHelper

  def account_containing_block(hash:)
    block_account(hash: hash).account
  end

  def account(address)
    NanoRpc::Account.new(address, node: self)
  end

  def accounts(addresses)
    NanoRpc::Accounts.new(addresses, node: self)
  end

  def clear_stats
    stats_clear.success == ''
  end

  def create_wallet(seed: nil)
    NanoRpc::Wallet.new(wallet_create(seed: seed).wallet, node: self)
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

  def wallet(id)
    NanoRpc::Wallet.new(id, node: self)
  end

  def work_valid?(work:, hash:)
    work_validate(work: work, hash: hash).valid == 1
  end
end

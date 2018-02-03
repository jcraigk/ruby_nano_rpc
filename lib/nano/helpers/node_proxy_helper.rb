# frozen_string_literal: true
module Nano::NodeProxyHelper
  include Nano::ApplicationHelper

  def account_containing_block(opts)
    block_account(opts_hash(opts)).account
  end

  def available
    available_supply.available
  end

  def create_wallet
    Nano::Wallet.new(wallet_create.wallet)
  end

  def krai_from(opts)
    krai_from_raw(opts_amount(opts)).amount
  end

  def krai_to(opts)
    krai_to_raw(opts_amount(opts)).amount
  end

  def mrai_from(opts)
    mrai_from_raw(opts_amount(opts)).amount
  end

  def mrai_to(opts)
    mrai_to_raw(opts_amount(opts)).amount
  end

  def pending_exists?(opts)
    pending_exists(opts_hash(opts)).exists == 1
  end

  def rai_from(opts)
    rai_from_raw(opts_amount(opts)).amount
  end

  def rai_to(opts)
    rai_to_raw(opts_amount(opts)).amount
  end

  def work_valid?(work:, hash:)
    work_validate(work: work, hash: hash).valid == 1
  end

  private

  def opts_amount(opts)
    { amount: opts_pluck(opts, :amount) }
  end

  def opts_hash(opts)
    { hash: opts_pluck(opts, :hash) }
  end
end

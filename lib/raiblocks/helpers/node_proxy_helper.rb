# frozen_string_literal: true
module Raiblocks::NodeProxyHelper
  def account_containing_block(hash)
    block_account(hash: hash).account
  end

  def available
    available_supply.available
  end

  def krai_from(amount:)
    krai_from_raw(amount: amount).amount
  end

  def krai_to(amount:)
    krai_to_raw(amount: amount).amount
  end

  def mrai_from(amount:)
    mrai_from_raw(amount: amount).amount
  end

  def mrai_to(amount:)
    mrai_to_raw(amount: amount).amount
  end

  def pending_exists?(hash:)
    pending_exists(hash: hash).exists == 1
  end

  def rai_from(amount:)
    rai_from_raw(amount: amount).amount
  end

  def rai_to(amount:)
    rai_to_raw(amount: amount).amount
  end

  def work_valid?(work:, hash:)
    work_validate(work: work, hash: hash).valid == 1
  end
end

# frozen_string_literal: true
module Nano::ApplicationHelper
  private

  def pluck_argument(args, key, arg_key = nil)
    k = arg_key || key
    arg = args.first
    v = arg.is_a?(Hash) ? arg[key] : arg
    { k => object_to_value(v) }
  end

  def object_to_value(arg)
    if arg.is_a?(Nano::Wallet)
      arg.seed
    elsif arg.is_a?(Nano::Account)
      arg.address
    elsif arg.is_a?(Nano::Accounts)
      arg.addresses
    else
      arg
    end
  end

  def inspect_prefix
    "#<#{self.class}:#{format('0x00%x', object_id << 1)}"
  end
end

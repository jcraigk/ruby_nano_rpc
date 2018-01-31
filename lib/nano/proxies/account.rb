# frozen_string_literal: true
class Nano::Account
  include Nano::Proxy
  include Nano::AccountProxyHelper

  attr_accessor :address

  def initialize(address = nil, opts = {})
    unless address.is_a?(String)
      raise Nano::MissingParameters,
            'Missing argument: address (str)'
    end

    @address = address
    @client = opts[:client] || Nano.client
  end

  proxy_params account: :address

  proxy_method :account_balance
  proxy_method :account_block_count
  proxy_method :account_info
  proxy_method :account_create, required: %i[wallet], optional: %i[work]
  proxy_method :account_history, required: %i[count]
  proxy_method :account_list
  proxy_method :account_move, required: %i[wallet source accounts]
  proxy_method :account_key
  proxy_method :account_remove, required: %i[wallet]
  proxy_method :account_representative
  proxy_method :account_representative_set, required: %i[wallet representative]
  proxy_method :account_weight
  proxy_method :delegators
  proxy_method :delegators_count
  proxy_method :frontiers, required: %i[count]
  proxy_method :frontier_count
  proxy_method :ledger,
               required: %i[count],
               optional: %i[representative weight pending sorting]
  proxy_method :validate_account_number
  proxy_method :pending, required: %i[count], optional: %i[threshold exists]
  proxy_method :payment_wait, required: %i[amount timeout]
  proxy_method :work_get
  proxy_method :work_set
end

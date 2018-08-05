# frozen_string_literal: true
class NanoRpc::Account
  include NanoRpc::Proxy
  include NanoRpc::AccountHelper

  attr_reader :address

  def initialize(address = nil, opts = {})
    unless address.is_a?(String)
      raise NanoRpc::MissingParameters,
            'Missing argument: address (str)'
    end

    @address = address
    super(opts)
  end

  proxy_params account: :address

  proxy_method :account_balance
  proxy_method :account_block_count
  proxy_method :account_info
  proxy_method :account_create, required: %i[wallet], optional: %i[work]
  proxy_method :account_history, required: %i[count]
  proxy_method :account_move, required: %i[wallet source accounts]
  proxy_method :account_key
  proxy_method :account_remove, required: %i[wallet]
  proxy_method :account_representative
  proxy_method :account_representative_set, required: %i[wallet representative]
  proxy_method :account_weight
  proxy_method :delegators
  proxy_method :delegators_count
  proxy_method :frontiers, required: %i[count]
  proxy_method :ledger,
               required: %i[count],
               optional: %i[
                 representative weight pending modified_since sorting
               ]
  proxy_method :validate_account_number
  proxy_method :pending, required: %i[count], optional: %i[threshold exists source]
  proxy_method :payment_wait, required: %i[amount timeout]
  proxy_method :receive, required: %i[wallet block], optional: %i[work]
  proxy_method :work_get, required: %i[wallet]
  proxy_method :work_set
end

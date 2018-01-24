# frozen_string_literal: true
class Raiblocks::Wallet
  include Raiblocks::Proxy
  include Raiblocks::WalletProxyHelper

  attr_accessor :seed

  def initialize(wallet_seed = nil, opts = {})
    unless wallet_seed.is_a?(String)
      raise Raiblocks::MissingParameters,
            'Missing argument: address (str)'
    end

    @seed = wallet_seed
    @client = opts[:client] || Raiblocks.client
  end

  proxy_params wallet: :seed

  proxy_method :wallet_add, required: %i[key], optional: %i[work]
  proxy_method :wallet_balance_total
  proxy_method :wallet_balances, optional: %i[threshold]
  proxy_method :wallet_change_seed, required: %i[seed]
  proxy_method :wallet_contains, required: %i[account]
  proxy_method :wallet_create
  proxy_method :wallet_destroy
  proxy_method :wallet_export
  proxy_method :wallet_frontiers
  proxy_method :wallet_locked
  proxy_method :wallet_pending,
               required: %i[count], optional: %i[threshold source]
  proxy_method :wallet_representative
  proxy_method :wallet_representative_set, required: %i[representative]
  proxy_method :wallet_republish, required: %i[count]
  proxy_method :wallet_work_get
  proxy_method :work_get
  proxy_method :work_set
  proxy_method :password_change, required: %i[password]
  proxy_method :password_enter, required: %i[password]
  proxy_method :password_valid
  proxy_method :payment_begin
  proxy_method :payment_init
  proxy_method :payment_end, required: %i[account]
  proxy_method :receive, required: %i[account block]
  proxy_method :send, required: %i[wallet source destination amount]
  proxy_method :search_pending
end

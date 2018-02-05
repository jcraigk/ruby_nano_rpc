# frozen_string_literal: true
class Nano::Wallet
  include Nano::Proxy
  include Nano::WalletProxyHelper

  attr_reader :seed

  def initialize(seed = nil, opts = {})
    unless seed.is_a?(String)
      raise Nano::MissingParameters,
            'Missing argument: address (str)'
    end

    @seed = seed
    super(opts)
  end

  # Hide secret seed during object inspection
  def inspect
    "#<#{self.class}:#{format('0x00%x', object_id << 1)}, " \
    "@client=#{@client.inspect}>"
  end

  proxy_params wallet: :seed

  proxy_method :account_create, optional: %i[work]
  proxy_method :accounts_create, required: %i[count], optional: %i[work]
  proxy_method :account_list
  proxy_method :account_remove, required: %i[account]
  proxy_method :password_change, required: %i[password]
  proxy_method :password_enter, required: %i[password]
  proxy_method :password_valid
  proxy_method :payment_begin
  proxy_method :payment_init
  proxy_method :payment_end, required: %i[account]
  proxy_method :receive, required: %i[account block], optional: %i[work]
  proxy_method :send, required: %i[wallet source destination amount]
  proxy_method :search_pending
  proxy_method :wallet_add, required: %i[key], optional: %i[work]
  proxy_method :wallet_balance_total
  proxy_method :wallet_balances, optional: %i[threshold]
  proxy_method :wallet_change_seed, required: %i[seed]
  proxy_method :wallet_contains, required: %i[account]
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
end

# frozen_string_literal: true
class RaiRpc::Accounts < RaiRpc::Proxy
  attr_accessor :addresses

  def initialize(addresses)
    unless addresses.is_a?(Array)
      raise RaiRpc::MissingArguments, 'Missing argument: addresses (str[])'
    end

    @addresses = addresses

    super
  end

  def model_params
    {
      accounts: :addresses
    }
  end

  def model_methods
    {
      accounts_balances: nil,
      accounts_create: { required: %i[wallet count], optional: %i[work] },
      accounts_frontiers: nil,
      accounts_pending: { required: %i[count], optional: %i[threshold source] }
    }
  end
end

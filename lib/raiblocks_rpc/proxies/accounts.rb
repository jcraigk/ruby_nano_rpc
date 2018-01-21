# frozen_string_literal: true
class RaiblocksRpc::Accounts < RaiblocksRpc::Proxy
  attr_accessor :addresses

  def initialize(addresses)
    unless addresses.is_a?(Array)
      raise RaiblocksRpc::MissingArguments,
            'Missing argument: addresses (str[])'
    end

    self.addresses = addresses
  end

  def model_params
    { accounts: :addresses }
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

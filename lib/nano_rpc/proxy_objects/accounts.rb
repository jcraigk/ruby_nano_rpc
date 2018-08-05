# frozen_string_literal: true
class NanoRpc::Accounts
  include NanoRpc::ProxyMethods::Accounts
  include NanoRpc::Proxy
  include NanoRpc::AccountsHelper

  attr_reader :addresses

  def initialize(addresses = nil, opts = {})
    unless addresses.is_a?(Array)
      raise NanoRpc::MissingParameters,
            'Missing argument: addresses (str[])'
    end

    @addresses = addresses
    super(opts)
  end
end

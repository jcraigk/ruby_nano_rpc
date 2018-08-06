# frozen_string_literal: true
class NanoRpc::Accounts
  include NanoRpc::AccountsHelper
  include NanoRpc::AccountsMethods
  include NanoRpc::Proxy

  attr_reader :addresses

  def initialize(addresses = nil, opts = {})
    unless addresses.is_a?(Array)
      raise NanoRpc::MissingParameters,
            'Missing argument: addresses (str[])'
    end

    @addresses = addresses
    super(opts)
  end

  def inspect
    "#{inspect_prefix}, @addresses=\"#{@addresses}\">"
  end
end

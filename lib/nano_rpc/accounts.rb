# frozen_string_literal: true

module NanoRpc
  # NanoRpc::Accounts wraps the concept of a set of Nano accounts
  #  * It exposes `addresses` as a persistent attribute
  #  * It exposes accounts-specific RPC methods (such as bulk creation)
  #  * It provides a number of convenience methods via mixins
  class Accounts
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
end

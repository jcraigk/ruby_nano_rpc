# frozen_string_literal: true

module NanoRpc
  # NanoRpc::Account wraps the concept of a Nano account
  #  * It exposes `address` as a persistent attribute
  #  * It exposes account-specific RPC methods
  #  * It provides a number of convenience methods via mixins
  class Account
    include NanoRpc::AccountHelper
    include NanoRpc::AccountMethods
    include NanoRpc::Proxy

    attr_reader :address

    def initialize(address = nil, opts = {})
      unless address.is_a?(String)
        raise NanoRpc::MissingParameters,
              'Missing argument: address (str)'
      end

      @address = address
      super(opts)
    end

    def inspect
      "#{inspect_prefix}, @address=\"#{@address}\">"
    end
  end
end

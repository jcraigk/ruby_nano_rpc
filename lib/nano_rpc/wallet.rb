# frozen_string_literal: true

module NanoRpc
  # NanoRpc::Wallet wraps the concept of a Nano wallet
  #  * It exposes `id` as a persistent attribute
  #  * It exposes wallet-specific RPC methods
  #  * It provides a number of convenience methods via mixins
  class Wallet
    include NanoRpc::Proxy
    include NanoRpc::WalletHelper
    include NanoRpc::WalletMethods

    attr_reader :id

    def initialize(id = nil, opts = {})
      unless id.is_a?(String)
        raise NanoRpc::MissingParameters,
              'Missing argument: id (str)'
      end

      @id = id
      super(opts)
    end

    def inspect
      "#{inspect_prefix}, @id=\"#{@id}\">"
    end
  end
end

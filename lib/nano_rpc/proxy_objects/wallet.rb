# frozen_string_literal: true
class NanoRpc::Wallet
  include NanoRpc::ProxyMethods::Wallet
  include NanoRpc::Proxy
  include NanoRpc::WalletHelper

  attr_reader :id

  def initialize(id = nil, opts = {})
    unless id.is_a?(String)
      raise NanoRpc::MissingParameters,
            'Missing argument: id (str)'
    end

    @id = id
    super(opts)
  end
end

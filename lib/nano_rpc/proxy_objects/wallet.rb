# frozen_string_literal: true
class NanoRpc::Wallet
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

  # Show only @id
  def inspect
    "#{inspect_prefix}, @id=\"#{@id}\">"
  end
end

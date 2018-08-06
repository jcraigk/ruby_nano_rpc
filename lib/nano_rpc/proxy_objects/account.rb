# frozen_string_literal: true
class NanoRpc::Account
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
end

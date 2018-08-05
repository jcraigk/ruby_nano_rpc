# frozen_string_literal: true
class NanoRpc::Account
  include NanoRpc::AccountHelper
  include NanoRpc::Methods::Account
  include NanoRpc::Proxy

  attr_reader :address

  def initialize(address = nil, opts = {})
    unless address.is_a?(String)
      raise NanoRpc::MissingParameters,
            'Missing argument: address (str)'
    end

    @address = address

    method_signatures.each { |k, v| self.class.proxy_method(k, v) }

    super(opts)
  end

  proxy_params account: :address
end

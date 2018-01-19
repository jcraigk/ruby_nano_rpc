# frozen_string_literal: true
require 'hashie'

class RaiRpc::Response < Hash
  include ::Hashie::Extensions::MergeInitializer
  include ::Hashie::Extensions::IndifferentAccess
  include ::Hashie::Extensions::MethodAccess

  def initialize(hash = {})
    super
    coerce_integers
  end

  def coerce_integers
    merge!(self) do |_k, v|
      Integer(v)
    rescue ArgumentError
      v
    end
  end
end

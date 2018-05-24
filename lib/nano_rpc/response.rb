# frozen_string_literal: true
require 'hashie'

class NanoRpc::Response < Hash
  include ::Hashie::Extensions::MergeInitializer
  include ::Hashie::Extensions::IndifferentAccess
  include ::Hashie::Extensions::MethodAccess

  def initialize(hash = {})
    super
    coerce_values
  end

  private

  def coerce_values
    merge!(self) { |_k, v| to_f_or_i_or_s(v) }
  end

  def to_f_or_i_or_s(val)
    return if val.nil?
    return val.to_i if big_integer?(val)
    (float = Float(val)) && (float % 1.0).zero? ? float.to_i : float
  rescue ArgumentError, TypeError
    val
  end

  def big_integer?(val)
    val.respond_to?(:to_i) && val.to_i > 1_000_000_000_000_000
  end
end

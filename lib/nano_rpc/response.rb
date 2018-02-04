# frozen_string_literal: true
require 'hashie'

class Nano::Response < Hash
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

  def to_f_or_i_or_s(v)
    return if v.nil?
    return v.to_i if big_integer?(v)
    (float = Float(v)) && (float % 1.0).zero? ? float.to_i : float
  rescue ArgumentError, TypeError
    v
  end

  def big_integer?(v)
    v.respond_to?(:to_i) && v.to_i > 1_000_000_000_000_000
  end
end

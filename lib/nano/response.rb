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
    (float = Float(v)) && (float % 1.0).zero? ? float.to_i : float
  rescue ArgumentError, TypeErrror
    v
  end
end

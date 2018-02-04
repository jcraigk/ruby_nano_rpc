# frozen_string_literal: true
class Nano::ProxyContext
  attr_reader :call_args

  def initialize(klass, m, call_args, base_params)
    @klass = klass
    @m = m
    @call_args = call_args
    @base_params = base_params

    validate_params!
  end

  # If single-key response matches method name, expose nested data
  def expose_nested_data(data)
    data.is_a?(Hash) && data.keys.map(&:to_s) == [@m.to_s] ? data[@m] : data
  end

  private

  def validate_params!
    prepare_params
    ensure_required_params!
    prevent_forbidden_params!
    drop_nil_params
  end

  def prepare_params
    # Allow non-Hash literal argument if this method requires single param
    # Ex `create('new')` vs `create(name: 'new')`
    @call_args = if required_params.size == 1 && !@call_args.is_a?(Hash)
                   { required_params.first => @call_args }
                 else
                   @call_args.is_a?(Hash) ? @call_args : {}
                 end
    @call_args.merge!(@base_params) if @base_params
  end

  def ensure_required_params!
    missing_params = required_params - opts_keys
    return unless missing_params.any?
    raise Nano::MissingParameters,
          "Missing required parameter(s): #{missing_params.join(', ')}"
  end

  def prevent_forbidden_params!
    forbidden_params = base_param_keys + opts_keys - allowed_params
    return unless forbidden_params.any?
    raise Nano::ForbiddenParameter,
          "Forbidden parameter(s) passed: #{forbidden_params.join(', ')}"
  end

  def drop_nil_params
    @call_args.delete_if { |_k, v| v.nil? }
  end

  def opts_keys
    @call_args.is_a?(Hash) ? @call_args.keys : []
  end

  def allowed_params
    base_param_keys + required_params + optional_params
  end

  def required_params
    return [] unless method_def && method_def[@m]
    method_def[@m][:required] || []
  end

  def optional_params
    return [] unless method_def && method_def[@m]
    method_def[@m][:optional] || []
  end

  def base_param_keys
    param_def.is_a?(Hash) ? param_def.keys : []
  end

  def method_def
    @klass.proxy_method_def
  end

  def param_def
    @klass.proxy_param_def
  end
end

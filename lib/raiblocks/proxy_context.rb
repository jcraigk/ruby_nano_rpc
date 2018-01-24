# frozen_string_literal: true
class Raiblocks::ProxyContext
  def initialize(klass, m, opts = {})
    @klass = klass
    @method_def = klass.proxy_method_def
    @param_def = klass.proxy_param_def
    @m = m
    @opts = opts
  end

  def valid_proxy_method?
    rpc_action?
  end

  def populate_params(params)
    opts = validate_opts!
    opts.merge!(params) if params
    validate_params!
    opts.delete_if { |_k, v| v.nil? }
    opts
  end

  def validate_opts!
    return @opts if @opts.is_a?(Hash)
    return {} if @opts.nil?
    raise Raiblocks::InvalidParameterType,
          'You must pass a hash to an action method'
  end

  def validate_params!
    ensure_required_params!
    ensure_no_forbidden_params!
  end

  def ensure_required_params!
    missing_params = required_params - opts_keys
    return unless missing_params.any?
    raise Raiblocks::MissingParameters,
          "Missing required parameter(s): #{missing_params.join(', ')}"
  end

  def ensure_no_forbidden_params!
    forbidden_params = base_param_keys + opts_keys - allowed_params
    return unless forbidden_params.any?
    raise Raiblocks::ForbiddenParameter,
          "Forbidden parameter(s) passed: #{forbidden_params.join(', ')}"
  end

  private

  def opts_keys
    @opts.nil? ? [] : @opts.keys
  end

  def allowed_params
    base_param_keys + required_params + optional_params
  end

  def required_params
    return [] unless @method_def && @method_def[@m]
    @method_def[@m][:required]
  end

  def optional_params
    return [] unless @method_def && @method_def[@m]
    @method_def[@m][:optional]
  end

  def base_param_keys
    @param_def.is_a?(Hash) ? @param_def.keys : []
  end

  def method_expansion
    "#{action_prefix}#{@m}"
  end

  def action_prefix
    @klass.name.split('::').last.downcase + '_'
  end
end

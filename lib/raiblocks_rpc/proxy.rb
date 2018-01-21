# frozen_string_literal: true
class RaiblocksRpc::Proxy
  attr_accessor :params, :param_signature, :m

  private

  def model_params
    raise 'Child class must override `model_params` method'
  end

  def model_methods
    raise 'Child class must override `model_methods` method'
  end

  # Define proxy methods based on #model_methods
  def method_missing(m, *args, &_block)
    self.m = m
    if valid_proxy_method?
      define_proxy_method(m)
      return send(m, args.first)
    end

    super
  end

  def respond_to_missing?(m, include_private = false)
    self.m = m
    valid_proxy_method? || super
  end

  # Valid proxy methods are:
  # (1) The raw name of an `action` as passed to the RPC server
  #     (e.g. `account_balance`)
  # (2) An abbreviation of an `action` such as `balance` from `account_balance`
  #     where `account` is the lowercase name of the encapsulating class.
  def valid_proxy_method?
    rpc_action? || rpc_action_abbrev?
  end

  def rpc_action
    return method_expansion if rpc_action_abbrev?
    m
  end

  def rpc_action?
    model_method_names.include?(m)
  end

  def rpc_action_abbrev?
    model_method_names.each do |model_method_name|
      model_method_name = model_method_name.to_s
      next unless model_method_name.start_with?(action_prefix)
      return true if m.to_s == action_abbrev(model_method_name)
    end

    false
  end

  def action_abbrev(model_method_name)
    model_method_name.to_s[action_prefix.size..-1]
  end

  def method_expansion
    "#{action_prefix}#{m}"
  end

  def model_method_names
    @model_method_names ||= model_methods.keys
  end

  def action_prefix
    @action_prefix ||= self.class.name.split('::').last.downcase + '_'
  end

  def define_proxy_method(m)
    self.class.send(:define_method, m) do |opts = {}|
      self.param_signature = model_methods[m.to_sym]
      self.params = validate_opts!(opts)

      populate_and_validate_params!
      RaiblocksRpc::Client.instance.call(rpc_action, params)
    end
  end

  def populate_and_validate_params!
    model_params.each { |k, v| self.params[k] ||= send(v) }
    validate_params!
  end

  def validate_params!
    return if param_signature.nil?
    ensure_required_params!
    ensure_no_forbidden_params!
  end

  def allowed_params
    model_params.keys +
    param_signature[:required] +
    param_signature[:optional]
  end

  def validate_opts!(opts)
    return opts if opts.is_a?(Hash)
    return {} if opts.nil?
    raise RaiblocksRpc::InvalidParameterType,
          'You must pass a hash to an action method'
  end

  def ensure_required_params!
    missing_params = param_signature[:required] - params.keys.map(&:to_sym)
    return unless missing_params.any?
    raise RaiblocksRpc::MissingParameters,
          "Missing required parameter(s): #{missing_params.join(', ')}"
  end

  def ensure_no_forbidden_params!
    forbidden_params = params.keys.map(&:to_sym) - allowed_params
    return unless forbidden_params.any?
    raise RaiblocksRpc::ForbiddenParameter,
          "Forbidden parameter(s) passed: #{forbidden_params.join(', ')}"
  end
end

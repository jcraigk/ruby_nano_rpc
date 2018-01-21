# frozen_string_literal: true
class RaiblocksRpc::Proxy
  private

  def model_params
    raise 'Child class must override `model_params` method'
  end

  def model_methods
    raise 'Child class must override `model_methods` method'
  end

  def method_missing(m, *args, &_block)
    if valid_proxy_method?(m)
      define_proxy_method(m, model_methods[m.to_sym], args)
      send(m)
    else
      super
    end
  end

  def respond_to_missing?(m, include_private = false)
    valid_proxy_method?(m) || super
  end

  # Valid proxy methods are:
  # (1) The raw name of an `action` as passed to the RPC server
  #     (e.g. `account_balance`)
  # (2) An abbreviation of an `action` such as `balance` from `account_balance`
  #     where `account` is the lowercase name of the encapsulating class.
  def valid_proxy_method?(m)
    rpc_action?(m) || rpc_action_abbrev?(m)
  end

  def rpc_action?(m)
    model_method_names.include?(m)
  end

  def rpc_action_abbrev?(m)
    model_method_names.each do |model_method_name|
      model_method_name = model_method_name.to_s
      next unless model_method_name.start_with?(action_prefix)
      return true if m.to_s == action_abbrev(model_method_name)
    end

    false
  end

  def action_abbrev(m)
    m.to_s[action_prefix.size..-1]
  end

  def method_expansion(m)
    "#{action_prefix}#{m}"
  end

  def model_method_names
    @model_method_names ||= model_methods.keys
  end

  def action_prefix
    @action_prefix ||= self.class.name.split('::').last.downcase + '_'
  end

  def define_proxy_method(m, param_signature, args)
    self.class.send(:define_method, m) do |options = {}|
      ensure_options_hash!(options)

      model_params.each { |k, v| options[k] ||= send(v) }
      options.merge!(args.first)
      validate_parameters!(options, param_signature)
      RaiblocksRpc::Client.instance.call(rpc_action(m), options)
    end
  end

  def rpc_action(m)
    return method_expansion(m) if rpc_action_abbrev?(m)
    m
  end

  def validate_parameters!(options, param_signature)
    return unless param_signature
    ensure_required_parameters!(options, param_signature)
    ensure_no_forbidden_parameters!(options, param_signature)
  end

  def allowed_parameters(param_signature)
    @allowed_parameters ||=
      model_params.keys +
      param_signature[:required] +
      param_signature[:optional]
  end

  def ensure_options_hash!(options)
    return if options.is_a?(Hash)
    raise RaiblocksRpc::InvalidParameterType,
          'You must pass a hash to an action method'
  end

  def ensure_required_parameters!(options, param_signature)
    missing_params = param_signature[:required] - options.keys.map(&:to_sym)
    return unless missing_params.any?
    raise RaiblocksRpc::MissingParameters,
          "Missing required parameter(s): #{missing_params.join(', ')}"
  end

  def ensure_no_forbidden_parameters!(options, param_signature)
    forbidden_params = options.keys.map(&:to_sym) -
                       allowed_parameters(param_signature)
    return unless forbidden_params.any?
    raise RaiblocksRpc::ForbiddenParameter,
          "Forbidden parameter(s) passed: #{forbidden_params.join(', ')}"
  end
end

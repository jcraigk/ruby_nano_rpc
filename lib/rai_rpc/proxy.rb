# frozen_string_literal: true
class RaiRpc::Proxy
  # def initialize(*_args)
  #   define_proxy_methods
  # end

  private

  def model_params
    raise 'Child class must override `model_params` method'
  end

  def model_methods
    raise 'Child class must override `model_methods` method'
  end

  def method_missing(method_name, *_args, &_block)
    if valid_proxy_method?(method_name)
      define_proxy_method(method_name, model_methods[method_name.to_sym])
      send(method_name)
    else
      super
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    valid_proxy_method?(method_name) || super
  end

  # Valid proxy methods are either:
  # (1) The name of an `action` as passed to the RPC server
  # (2) An abbreviation of an `action` such as `account_balance` => `account`
  #     where `account` is the lowercase name of the encapsulating class
  def valid_proxy_method?(method_name)
    rpc_action?(method_name) || rpc_action_abbrev?(method_name)
  end

  def rpc_action?(method_name)
    model_method_names.include?(method_name)
  end

  def rpc_action_abbrev?(method_name)
    model_method_names.each do |model_method_name|
      model_method_name = model_method_name.to_s
      next unless model_method_name.start_with?(action_prefix)
      return true if method_name.to_s == action_abbrev(model_method_name)
    end

    false
  end

  def action_abbrev(method_name)
    method_name.to_s[action_prefix.size..-1]
  end

  def method_expansion(method_name)
    "#{action_prefix}#{method_name}"
  end

  def model_method_names
    @model_method_names ||= model_methods.keys
  end

  def action_prefix
    @action_prefix ||= self.class.name.split('::').last.downcase + '_'
  end

  def define_proxy_method(method_name, param_signature)
    self.class.send(:define_method, method_name) do |options = {}|
      validate_parameters!(param_signature, options)
      model_params.each { |k, v| options[k] ||= send(v) }
      RaiRpc::Client.instance.call(rpc_action(method_name), options)
    end
  end

  def rpc_action(method_name)
    return method_expansion(method_name) if rpc_action_abbrev?(method_name)
    method_name
  end

  def validate_parameters!(param_signature, options)
    return unless param_signature.is_a?(Hash)
    missing_params = param_signature[:required] -
                     options.keys.map(&:to_sym)
    ensure_required_parameters!(missing_params)
  end

  def ensure_required_parameters!(missing_params)
    return unless missing_params.any?
    raise RaiRpc::MissingParameters,
          "Missing required parameter(s): #{missing_params.join(', ')}"
  end
end

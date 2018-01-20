# frozen_string_literal: true
class RaiRpc::Proxy
  def initialize(*_args)
    define_proxy_methods
  end

  private

  def model_params
    raise 'Child class must override `model_params` method'
  end

  def model_methods
    raise 'Child class must override `model_methods` method'
  end

  # Define proxy methods as described by including class's `model_methods` hash
  # Uses including class's `model_params` as default parameters
  def define_proxy_methods
    model_methods.each do |method_name, param_signature|
      define_rpc_methods(method_name, param_signature)
    end
  end

  def define_rpc_methods(method_name, param_signature)
    method_list(method_name.to_s).each do |props|
      self.class.send(:define_method, props[:method]) do |options = {}|
        validate_parameters!(param_signature, options)

        model_params.each { |k, v| options[k] ||= send(v) }
        RaiRpc::Client.instance.query(props[:action], options)
      end
    end
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

  # Provide a method with same name as RPC action
  # Also provide abbreviated method if prefixed by class name
  # `account_balance` => `balance`
  def method_list(method_name)
    [{ method: method_name, action: method_name }].tap do |method_list|
      method_prefix = self.class.name.split('::').last.downcase + '_'
      if method_name.start_with?(method_prefix)
        method_list << {
          method: method_name[method_prefix.size..-1],
          action: method_name
        }
      end
    end
  end
end

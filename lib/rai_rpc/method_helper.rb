# frozen_string_literal: true
module RaiRpc::MethodHelper
  def instantiate_methods
    model_methods.each do |method_name, param_signature|
      define_rpc_methods(method_name, param_signature, model_params)
    end
  end

  def define_rpc_methods(method_name, param_signature, model_params)
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

  def method_list(method_name)
    method_list = [{ method: method_name, action: method_name }]
    # Provide abbreviated convenience method if redundant prefix present
    # `account_balance` => `balance`
    if method_name.start_with?(method_prefix)
      method_list << {
        method: method_name[method_prefix.size..-1],
        action: method_name
      }
    end

    method_list
  end
end

# frozen_string_literal: true
module RaiRpc::MethodHelper
  def instantiate_methods
    model_methods.each do |method_name, param_signature|
      define_rpc_method(
        method_name,
        method_name,
        param_signature,
        model_params
      )

      # Also define shortcut method by dropping method prefix
      next unless (method_name = method_name.to_s).start_with?(method_prefix)
      define_rpc_method(
        method_name[method_prefix.size..-1],
        method_name,
        param_signature,
        model_params
      )
    end
  end

  def define_rpc_method(method_name, action, param_signature, model_params)
    self.class.send(:define_method, method_name) do |options = {}|
      model_params.each { |k, v| options[k] ||= send(v) }
      if param_signature.is_a?(Hash)
        missing_params = param_signature[:required] -
                         options.keys.map(&:to_sym)
        ensure_parameters!(missing_params)
      end

      RaiRpc::Client.instance.query(action, options)
    end
  end

  def ensure_parameters!(missing_params)
    return unless missing_params.any?
    raise RaiRpc::MissingParameters,
          "Missing required parameter(s): #{missing_params.join(', ')}"
  end
end

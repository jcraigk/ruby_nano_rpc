# frozen_string_literal: true
module RubyRai::MethodHelper
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def instantiate_methods
      model_methods.each do |type, method_signatures|
        method_signatures.each do |method_name, param_signature|
          define_rpc_method(
            method_name,
            param_signature,
            model_params,
            prefix: (type == :prefixed ? method_prefix : nil)
          )
        end
      end
    end

    def define_rpc_method(method_name, param_signature, model_params, prefix: '')
      define_method(method_name) do |options = {}|
        model_params.each do |k, v|
          options[k] ||= instance_variable_get("@#{v}")
        end
        if param_signature.is_a?(Hash)
          missing_params = param_signature[:required] - options.keys.map(&:to_sym)
          raise RubyRai::MissingParameters.new("Missing required parameter(s): #{missing_params.join(', ')}") if missing_params.any?
        end
        action = prefix ? "#{prefix}_#{method_name}" : method_name
        RubyRai::Client.instance.query(action, options)
      end
    end
  end
end

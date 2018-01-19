# frozen_string_literal: true
module RubyRai::ClientHelper
  def self.included base
    base.send :include, InstanceMethods
    base.extend ClassMethods
  end

  module InstanceMethods
    def client
      RubyRai::Client.instance
    end
  end

  module ClassMethods
    def define_rpc_method(method_name, param_signature, prefix: '')
      define_method(method_name) do |options = {}|
        options[:account] ||= public_key
        if param_signature.is_a?(Hash)
          missing_params = param_signature[:required] - options.keys.map(&:to_sym)
          raise RubyRai::MissingParameters.new("Missing required parameter(s): #{missing_params.join(', ')}") if missing_params.any?
        end
        action = prefix ? "#{prefix}_#{method_name}" : method_name
        client.query(action, options)
      end
    end
  end
end
# frozen_string_literal: true
module NanoRpc::Proxy
  attr_reader :node

  def initialize(opts = {})
    @node = @node || opts[:node] || NanoRpc.node
    proxy_methods.each { |meth, _| define_proxy_method(meth) }
  end

  private

  def define_proxy_method(meth)
    self.class.send(:define_method, method_alias(meth)) do |args = {}|
      @meth = meth
      @call_args = args
      validate_params
      execute_call
    end
  end

  def execute_call
    result = node.call(@meth, @call_args)
    expose_nested_data(result)
  end

  def base_params
    @base_params ||=
      proxy_params.each_with_object({}) do |(k, v), params|
        params[k] ||= send(v)
      end
  end

  # Nano `send` action is also the method caller in Ruby ;)
  def method_alias(meth)
    meth == :send ? :send_currency : meth
  end

  # If single-key response matches method name, expose nested data
  def expose_nested_data(data)
    if data.is_a?(Hash) && data.keys.map(&:to_s) == [@meth.to_s]
      return data[@meth]
    end
    data
  end

  def validate_params
    prepare_params
    ensure_required_params
    prevent_forbidden_params
    drop_nil_params
  end

  def prepare_params
    # Allow non-Hash literal argument if this method requires single param
    # Ex `create('new')` vs `create(name: 'new')`
    @call_args =
      if required_params.size == 1 && !@call_args.is_a?(Hash)
        { required_params.first => @call_args }
      else
        @call_args.is_a?(Hash) ? @call_args : {}
      end
    @call_args.merge!(base_params) if base_params
  end

  def ensure_required_params
    missing_params = required_params - opts_keys
    return unless missing_params.any?
    raise NanoRpc::MissingParameters,
          "Missing required parameter(s): #{missing_params.join(', ')}"
  end

  def prevent_forbidden_params
    forbidden_params = base_param_keys + opts_keys - allowed_params
    return unless forbidden_params.any?
    raise NanoRpc::ForbiddenParameter,
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
    return [] unless proxy_methods[@meth]
    proxy_methods[@meth][:required] || []
  end

  def optional_params
    return [] unless proxy_methods[@meth]
    proxy_methods[@meth][:optional] || []
  end

  def base_param_keys
    proxy_params.keys
  end
end

# frozen_string_literal: true
module Nano::Proxy
  attr_accessor :client

  def initialize(opts = {})
    @client = opts[:client] || Nano.client
  end

  def self.included(base)
    base.extend(ClassMethods)
  end
  module ClassMethods
    attr_reader :proxy_method_def, :proxy_param_def

    def proxy_params(param_def = nil)
      @proxy_param_def = param_def
    end

    def proxy_method(name, signature = nil)
      @proxy_method_def ||= {}
      @proxy_method_def[name] = signature
    end

    def proxy_methods
      proxy_method_def.keys.sort
    end

    def methods
      (super + proxy_methods).sort
    end

    def define_proxy_method(m, singleton = false)
      send(
        singleton ? :define_singleton_method : :define_method,
        method_alias(m)
      ) do |opts = {}|
        params = Nano::ProxyContext.new(
          singleton ? self : self.class, m, opts
        ).populate_params(singleton ? nil : base_params)
        data = Nano.client.call(m, params)
        data.is_a?(Hash) && data.keys.map(&:to_s) == [m.to_s] ? data[m] : data
      end
    end

    private

    # Nano `send` action is also the method caller in Ruby ;)
    def method_alias(m)
      m == :send ? :tx_send : m
    end

    def method_missing(m, *args, &_block)
      return super unless valid_method?(m)
      define_proxy_method(m, true)
      send(m, args.first)
    end

    def respond_to_missing?(m, include_private = false)
      valid_method?(m) || super
    end

    def valid_method?(m)
      proxy_param_def.nil? && methods.include?(m)
    end

    def proxy_context(m)
      @proxy_context ||= {}
      @proxy_context[m] ||= Nano::ProxyContext.new(self, m)
    end
  end

  def proxy_methods
    self.class.proxy_methods
  end

  def methods
    (super + proxy_methods).sort
  end

  private

  def base_params
    return if self.class.proxy_param_def.nil?
    self.class
        .proxy_param_def
        .each_with_object({}) do |(k, v), params|
      params[k] ||= send(v)
    end
  end

  def method_missing(m, *args, &_block)
    return super unless methods.include?(m)
    self.class.define_proxy_method(m)
    send(m, args.first)
  end

  def respond_to_missing?(m, include_private = false)
    methods.include?(m) || super
  end
end

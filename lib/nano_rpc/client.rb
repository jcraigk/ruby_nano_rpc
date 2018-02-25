# frozen_string_literal: true
require 'rest-client'
require 'json'

module Nano
  def self.client
    @client ||= Client.new
  end

  class Client
    include Nano::ApplicationHelper

    attr_accessor :host, :port, :auth

    def initialize(host: 'localhost', port: 7076, auth: nil)
      @host = host
      @port = port
      @auth = auth
    end

    # Condense host/port on object inspection
    def inspect
      "#{inspect_prefix}, @url=\"#{@host}:#{port}\">"
    end

    def call(action, params = {})
      args = { action: action }
      args.merge!(params) if params.is_a?(Hash)
      args = extract_proxy_args(args)
      rpc_post(args)
    end

    private

    def extract_proxy_args(args)
      args.each do |k, v|
        m = proxy_method(v)
        args[k] = v.send(m) if m
      end
      args
    end

    def proxy_method(v)
      if v.is_a?(Nano::Wallet)
        :seed
      elsif v.is_a?(Nano::Accounts)
        :addresses
      elsif v.is_a?(Nano::Account)
        :address
      end
    end

    def rpc_post(params)
      response = rest_client_post(url, params)
      ensure_status_success!(response)

      data = Nano::Response.new(JSON[response.body])
      ensure_valid_response!(data)

      data
    end

    def headers
      if @auth.nil?
        {"Content-Type" => "json"}
      else
        {"Authorization" => @auth, "Content-Type" => "json"}
      end
    end

    def rest_client_post(url, params)
      RestClient.post(url, params.to_json, headers)
    rescue Errno::ECONNREFUSED
      raise Nano::NodeConnectionFailure,
            "Node connection failure at #{url}"
    rescue RestClient::Exceptions::OpenTimeout
      raise Nano::NodeOpenTimeout,
            'Node failed to respond in time'
    end

    def url
      if host.start_with?("http://") || host.start_with?("https://")
        "#{host}:#{port}"
      else
        "http://#{host}:#{port}"
      end
    end

    def ensure_status_success!(response)
      return if response.code == 200
      raise Nano::BadRequest,
            "Error response from node: #{JSON[response.body]}"
    end

    def ensure_valid_response!(data)
      return unless data['error']
      raise Nano::InvalidRequest,
            "Invalid request: #{data['error']}"
    end
  end
end

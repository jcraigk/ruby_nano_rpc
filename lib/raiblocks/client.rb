# frozen_string_literal: true
require 'rest-client'
require 'json'

module Raiblocks
  def self.client
    @client ||= Client.new
  end

  class Client
    attr_accessor :host, :port

    def initialize(host: 'localhost', port: 7076)
      @host = host
      @port = port
    end

    def call(action, params = {})
      args = { action: action }
      args.merge!(params) if params.is_a?(Hash)
      post(args)
    end

    private

    def post(params)
      response = rest_client_post(url, params)
      ensure_status_success!(response)

      data = Raiblocks::Response.new(JSON[response.body])
      ensure_valid_response!(data)

      data
    end

    def rest_client_post(url, params)
      RestClient.post(url, params.to_json)
    rescue Errno::ECONNREFUSED
      raise Raiblocks::NodeConnectionFailure,
            "Node connection failure at #{url}"
    end

    def url
      "http://#{host}:#{port}"
    end

    def ensure_status_success!(response)
      return if response.code == 200
      raise Raiblocks::BadRequest,
            "Error response from node: #{JSON[response.body]}"
    end

    def ensure_valid_response!(data)
      return unless data['error']
      raise Raiblocks::InvalidRequest,
            "Invalid request: #{data['error']}"
    end
  end
end

# frozen_string_literal: true
require 'rest-client'
require 'json'

module NanoRpc
  def self.node
    @node ||= Node.new
  end
end

class NanoRpc::Node
  include NanoRpc::NodeHelper
  include NanoRpc::NodeMethods
  include NanoRpc::Proxy

  attr_reader :host, :port, :auth, :headers, :node, :timeout

  DEFAULT_TIMEOUT = 60

  require 'pry'
  def initialize(
    host: 'localhost',
    port: 7076,
    auth: nil,
    headers: nil,
    timeout: DEFAULT_TIMEOUT
  )
    @host = host
    @port = port
    @auth = auth
    @headers = headers
    @timeout = timeout
    @node = self

    super
  end

  def call(action, params = {})
    args = { action: action }
    args.merge!(params) if params.is_a?(Hash)
    args = extract_proxy_args(args)
    rpc_post(args)
  end

  def inspect
    "#{inspect_prefix}, @url=\"#{@host}:#{port}\">"
  end

  private

  def extract_proxy_args(args)
    args.each do |k, v|
      m = proxy_method_name(v)
      args[k] = v.send(m) if m
    end
    args
  end

  def proxy_method_name(obj)
    if obj.is_a?(NanoRpc::Wallet)
      :id
    elsif obj.is_a?(NanoRpc::Accounts)
      :addresses
    elsif obj.is_a?(NanoRpc::Account)
      :address
    end
  end

  def rpc_post(params)
    response = rest_client_post(params)
    ensure_status_success(response)
    data = NanoRpc::Response.new(JSON[response&.body])
    ensure_valid_response(data)

    data
  end

  def request_headers
    h = headers || {}
    h['Content-Type'] = 'json'
    h['Authorization'] = auth unless auth.nil?
    h
  end

  def rest_client_post(params)
    execute_post(params)
  rescue Errno::ECONNREFUSED
    raise NanoRpc::NodeConnectionFailure,
          "Node connection failure at #{url}"
  rescue RestClient::Exceptions::OpenTimeout
    raise NanoRpc::NodeOpenTimeout,
          'Node failed to respond in time'
  end

  def execute_post(params)
    RestClient::Request.execute(
      method: :post,
      url: url,
      headers: request_headers,
      payload: params.to_json,
      timeout: timeout
    )
  end

  def url
    if host.start_with?('http://', 'https://')
      "#{host}:#{port}"
    else
      "http://#{host}:#{port}"
    end
  end

  def ensure_status_success(response)
    return if response&.code == 200
    raise NanoRpc::BadRequest,
          "Error response from node: #{JSON[response&.body]}"
  end

  def ensure_valid_response(data)
    return unless data['error']
    raise NanoRpc::InvalidRequest,
          "Invalid request: #{data['error']}"
  end
end

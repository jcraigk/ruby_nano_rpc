# frozen_string_literal: true
require 'rest-client'
require 'json'

module NanoRpc
  def self.node
    @node ||= Node.new
  end
end

class NanoRpc::Node
  include NanoRpc::Proxy
  include NanoRpc::NodeHelper

  attr_reader :host, :port, :auth, :headers, :node, :timeout

  DEFAULT_TIMEOUT = 20

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

  # Condense host/port on object inspection
  def inspect
    "#{inspect_prefix}, @url=\"#{@host}:#{port}\">"
  end

  proxy_method :available_supply
  proxy_method :block, required: %i[hash]
  proxy_method :block_account, required: %i[hash]
  proxy_method :block_confirm, required: %i[hash]
  proxy_method :block_count
  proxy_method :block_count_type
  proxy_method :block_create,
               required: %i[type key representative source],
               optional: %i[work]
  proxy_method :blocks, required: %i[hashes]
  proxy_method :blocks_info,
               required: %i[hashes],
               optional: %i[pending source balance]
  proxy_method :bootstrap, required: %i[address port]
  proxy_method :bootstrap_any
  proxy_method :chain, required: %i[block count]
  proxy_method :confirmation_history
  proxy_method :deterministic_key, required: %i[seed index]
  proxy_method :frontier_count
  proxy_method :history, required: %i[hash count]
  proxy_method :keepalive, required: %i[address port]
  proxy_method :key_create
  proxy_method :key_expand, required: %i[key]
  proxy_method :krai_from_raw, required: %i[amount]
  proxy_method :krai_to_raw, required: %i[amount]
  proxy_method :mrai_from_raw, required: %i[amount]
  proxy_method :mrai_to_raw, required: %i[amount]
  proxy_method :payment_wait, required: %i[account amount   eout]
  proxy_method :peers
  proxy_method :pending_exists, required: %i[hash]
  proxy_method :process, required: %i[block]
  proxy_method :rai_from_raw, required: %i[amount]
  proxy_method :rai_to_raw, required: %i[amount]
  proxy_method :receive_minimum
  proxy_method :receive_minimum_set, required: %i[amount]
  proxy_method :representatives
  proxy_method :representatives_online
  proxy_method :republish,
               required: %i[hash],
               optional: %i[count sources destinations]
  proxy_method :search_pending, required: %i[wallet]
  proxy_method :search_pending_all
  proxy_method :stats, required: %i[type]
  proxy_method :stop
  proxy_method :successors, required: %i[block count]
  proxy_method :unchecked, required: %i[count]
  proxy_method :unchecked_clear
  proxy_method :unchecked_get, required: %i[hash]
  proxy_method :unchecked_keys, required: %i[key count]
  proxy_method :receive_minimum
  proxy_method :receive_minimum_set, required: %i[amount]
  proxy_method :representatives
  proxy_method :representatives_online
  proxy_method :republish,
               required: %i[hash],
               optional: %i[count sources destinations]
  proxy_method :search_pending, required: %i[wallet]
  proxy_method :search_pending_all
  proxy_method :stats, required: %i[type]
  proxy_method :stop
  proxy_method :successors, required: %i[block count]
  proxy_method :unchecked, required: %i[count]
  proxy_method :unchecked_clear
  proxy_method :unchecked_get, required: %i[hash]
  proxy_method :unchecked_keys, required: %i[key count]
  proxy_method :version
  proxy_method :wallet_create
  proxy_method :work_cancel, required: %i[hash]
  proxy_method :work_generate,
               required: %i[hash],
               optional: %i[use_peers]
  proxy_method :work_peer_add, required: %i[address port]
  proxy_method :work_peers
  proxy_method :work_peers_clear
  proxy_method :work_validate, required: %i[work hash]

  private

  def extract_proxy_args(args)
    args.each do |k, v|
      m = proxy_method(v)
      args[k] = v.send(m) if m
    end
    args
  end

  def proxy_method(obj)
    if obj.is_a?(NanoRpc::Wallet)
      :seed
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

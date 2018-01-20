# frozen_string_literal: true
require 'singleton'
require 'rest-client'
require 'json'
require 'pry' # TODO remove

class RaiRpc::Client
  include Singleton

  class << self
    attr_accessor :host, :port
  end

  def call(action, params = {})
    post({ action: action }.merge(params))
  end

  private

  def post(params)
    response = RestClient.post(url, params.to_json)
    ensure_status_success!(response)

    data = RaiRpc::Response.new(JSON[response.body])
    ensure_valid_response!(data)

    data
  end

  def url
    self.class.host ||= 'localhost'
    self.class.port ||= 7076
    "http://#{self.class.host}:#{self.class.port}"
  end

  def ensure_status_success!(response)
    return if response.code == 200
    raise RaiRpc::BadRequest, "Error response from node: #{JSON[response.body]}"
  end

  def ensure_valid_response!(data)
    return unless data['error']
    raise RaiRpc::InvalidRequest, "Invalid request: #{data['error']}"
  end
end

# frozen_string_literal: true
require 'singleton'
require 'rest-client'
require 'json'
require 'pry' # TODO remove

class RubyRai::Client
  include Singleton

  class << self
    attr_accessor :host, :port
  end

  def query(action, params = {})
    post({ action: action }.merge(params))
  end

  private

  def post(params)
    resp = RestClient.post(url, params.to_json)
    raise RubyRai::BadRequest.new('Error response from node') unless resp.code == 200
    data = RubyRai::Response.new(JSON[resp.body])
    raise RubyRai::InvalidRequest.new("Invalid request: #{data['error']}") if data['error']
    puts data
  end

  def url
    # raise 'RubyRai::Client.host not configured!' unless self.class.host
    self.class.host = 'localhost'
    self.class.port = 7076
    "http://#{self.class.host}:#{self.class.port}"
  end
end

# frozen_string_literal: true
require 'raiblocks_rpc/client'
require 'raiblocks_rpc/errors'
require 'raiblocks_rpc/proxy'
require 'raiblocks_rpc/response'
require 'raiblocks_rpc/version'
require 'raiblocks_rpc/proxies/account'
require 'raiblocks_rpc/proxies/accounts'
require 'raiblocks_rpc/proxies/network'
require 'raiblocks_rpc/proxies/node'
require 'raiblocks_rpc/proxies/util'
require 'raiblocks_rpc/proxies/wallet'

module RaiblocksRpc
  def self.client
    @client ||= Client.new
  end
end

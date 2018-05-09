# frozen_string_literal: true
class Nano::Node
  include Nano::Proxy
  include Nano::NodeHelper

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
  proxy_method :payment_wait, required: %i[account amount timeout]
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
  proxy_method :stats, require: %i[type]
  proxy_method :stop
  proxy_method :successors, required: %i[block count]
  proxy_method :unchecked, required: %i[count]
  proxy_method :unchecked_clear
  proxy_method :unchecked_get, required: %i[hash]
  proxy_method :unchecked_keys, required: %i[key count]
  proxy_method :version
  proxy_method :wallet_create
  proxy_method :work_cancel, required: %i[hash]
  proxy_method :work_generate, required: %i[hash]
  proxy_method :work_peer_add, required: %i[address port]
  proxy_method :work_peers
  proxy_method :work_peers_clear
  proxy_method :work_validate, required: %i[work hash]
end

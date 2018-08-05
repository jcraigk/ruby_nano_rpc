# frozen_string_literal: true
module NanoRpc::ProxyMethods::Node
  def method_signatures # rubocop:disable Metrics/MethodLength
    {
      available_supply: {},
      block: {
        required: %i[hash]
      },
      block_account: {
        required: %i[hash]
      },
      block_confirm: {
        required: %i[hash]
      },
      block_count: {},
      block_count_type: {},
      block_create: {
        required: %i[type key representative source],
        optional: %i[work]
      },
      blocks: {
        required: %i[hashes]
      },
      blocks_info: {
        required: %i[hashes],
        optional: %i[pending source balance]
      },
      bootstrap: {
        required: %i[address port]
      },
      bootstrap_any: {},
      chain: {
        required: %i[block count]
      },
      confirmation_history: {},
      deterministic_key: {
        required: %i[seed index]
      },
      frontier_count: {},
      history: {
        required: %i[hash count]
      },
      keepalive: {
        required: %i[address port]
      },
      key_create: {},
      key_expand: {
        required: %i[key]
      },
      krai_from_raw: {
        required: %i[amount]
      },
      krai_to_raw: {
        required: %i[amount]
      },
      mrai_from_raw: {
        required: %i[amount]
      },
      mrai_to_raw: {
        required: %i[amount]
      },
      payment_wait: {
        required: %i[account amount timeout]
      },
      peers: {},
      pending_exists: {
        required: %i[hash]
      },
      process: {
        required: %i[block]
      },
      rai_from_raw: {
        required: %i[amount]
      },
      rai_to_raw: {
        required: %i[amount]
      },
      receive_minimum: {},
      receive_minimum_set: {
        required: %i[amount]
      },
      representatives: {},
      representatives_online: {},
      republish: {
        required: %i[hash],
        optional: %i[count sources destinations]
      },
      search_pending: {
        required: %i[wallet]
      },
      search_pending_all: {},
      stats: {
        required: %i[type]
      },
      stop: {},
      successors: {
        required: %i[block count]
      },
      unchecked: {
        required: %i[count]
      },
      unchecked_clear: {},
      unchecked_get: {
        required: %i[hash]
      },
      unchecked_keys: {
        required: %i[key count]
      },
      version: {},
      wallet_create: {},
      work_cancel: {
        required: %i[hash]
      },
      work_generate: {
        required: %i[hash],
        optional: %i[use_peers]
      },
      work_peer_add: {
        required: %i[address port]
      },
      work_peers: {},
      work_peers_clear: {},
      work_validate: {
        required: %i[work hash]
      }
    }
  end
end

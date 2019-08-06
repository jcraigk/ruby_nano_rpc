# frozen_string_literal: true

module NanoRpc
  # Signatures for Nano node RPC methods
  module NodeMethods # rubocop:disable Metrics/ModuleLength
    def proxy_params
      {}
    end

    def proxy_methods # rubocop:disable Metrics/MethodLength
      {
        active_difficulty: {},
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
          optional: %i[work json_block]
        },
        block_hash: {
          optional: %i[json_block]
        },
        block_info: {
          required: %i[hash],
          optional: %i[json_block]
        },
        blocks: {
          required: %i[hashes]
        },
        blocks_info: {
          required: %i[hashes],
          optional: %i[pending source balance json_block]
        },
        bootstrap: {
          required: %i[address port]
        },
        bootstrap_any: {},
        bootstrap_lazy: {
          required: %i[hash],
          optional: %i[force]
        },
        bootstrap_status: {},
        chain: {
          required: %i[block count],
          optional: %i[offset reverse]
        },
        confirmation_active: {
          optional: %i[announcements]
        },
        confirmation_height_currently_processing: {},
        confirmation_history: {},
        confirmation_info: {
          required: %i[root],
          optional: %i[contents representatives json_block]
        },
        confirmation_quorum: {
          optional: %i[peer_details]
        },
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
        node_id: {},
        node_id_delete: {},
        payment_wait: {
          required: %i[account amount timeout]
        },
        peers: {
          optional: %i[peer_details]
        },
        pending_exists: {
          required: %i[hash],
          optional: %i[include_active include_only_confirmed]
        },
        process: {
          required: %i[block],
          optional: %i[force subtype json_block]
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
        sign: {
          optional: %i[account hash key wallet json_block]
        },
        stats: {
          required: %i[type]
        },
        stats_clear: {},
        stop: {},
        successors: {
          required: %i[block count],
          optional: %i[offset reverse]
        },
        unchecked: {
          required: %i[count]
        },
        unchecked_clear: {},
        unchecked_get: {
          required: %i[hash],
          optional: %i[json_block]
        },
        unchecked_keys: {
          required: %i[key count],
          optional: %i[json_block]
        },
        unopened: {
          optional: %i[account count]
        },
        uptime: {},
        version: {},
        wallet_create: {
          optional: %i[seed]
        },
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
end

# frozen_string_literal: true
class RaiblocksRpc::Node < RaiblocksRpc::Proxy
  def proxy_methods
    {
      bootstrap: { required: %i[address port] },
      bootstrap_any: nil,
      keepalive: { required: %i[address port] },
      work_peer_add: { required: %i[address port] },
      deterministic_key: { required: %i[seed index] },
      receive_minimum: nil,
      receive_minimum_set: { required: %i[amount] },
      representatives: nil,
      stop: nil,
      version: nil,
      peers: nil,
      work_peers: nil,
      work_peers_clear: nil,
      work_validate: { required: %i[work hash] },
      search_pending: { required: %i[wallet] },
      search_pending_all: nil,
      available_supply: nil,
      block: { required: %i[hash] },
      blocks: { required: %i[hashes] },
      blocks_info: { required: %i[hashes], optional: %i[pending source] },
      block_account: { required: %i[hash] },
      block_count: nil,
      block_count_type: nil,
      unchecked: { required: %i[count] },
      unchecked_clear: nil,
      unchecked_get: { required: %i[hash] },
      unchecked_keys: { required: %i[key count] },
      payment_wait: { required: %i[account amount timeout] }
    }
  end
end

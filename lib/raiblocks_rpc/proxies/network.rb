# frozen_string_literal: true
class RaiblocksRpc::Network < RaiblocksRpc::Proxy
  def model_params
    {}
  end

  def model_methods
    {
      available_supply: nil,
      block: { required: %i[hash] },
      blocks: { required: %i[hashes] },
      blocks_info: { required: %i[hashes], optional: %i[pending source] },
      block_account: { required: %i[hash] },
      block_count: nil,
      block_count_type: nil,
      chain: { required: %i[block count] },
      history: { required: %i[hash count] },
      block_create: {
        required: %i[type key representative source], optional: %i[work]
      },
      process: { required: %i[block] },
      republish: {
        required: %i[hash], optional: %i[count sources destinations]
      },
      successors: { required: %i[block count] },
      pending_exists: { required: %i[hash] },
      unchecked: { required: %i[count] },
      unchecked_clear: nil,
      unchecked_get: { required: %i[hash] },
      unchecked_keys: { required: %i[key count] },
      work_cancel: { required: %i[hash] },
      work_generate: { required: %i[hash] },
      payment_wait: { required: %i[account amount timeout] },
      work_validate: { required: %i[work hash] },
      bootstrap: { required: %i[address port] },
      keepalive: { required: %i[address port] },
      work_peer_add: { required: %i[address port] },
      bootstrap_any: nil
    }
  end
end

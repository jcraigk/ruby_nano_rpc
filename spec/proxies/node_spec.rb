# frozen_string_literal: true
require 'spec_helper'

RSpec.describe NanoRpc::Node do
  subject { described_class.new }
  let(:expected_proxy_methods) do
    %i[
      available_supply
      block
      block_account
      block_confirm
      block_count
      block_count_type
      block_create
      blocks
      blocks_info
      bootstrap
      bootstrap_any
      chain
      confirmation_history
      deterministic_key
      frontier_count
      history
      keepalive
      key_create
      key_expand
      krai_from_raw
      krai_to_raw
      mrai_from_raw
      mrai_to_raw
      payment_wait
      peers
      pending_exists
      process
      rai_from_raw
      rai_to_raw
      receive_minimum
      receive_minimum_set
      representatives
      representatives_online
      republish
      search_pending
      search_pending_all
      stats
      stop
      successors
      unchecked
      unchecked_clear
      unchecked_get
      unchecked_keys
      version
      wallet_create
      work_cancel
      work_generate
      work_peer_add
      work_peers
      work_peers_clear
      work_validate
    ]
  end

  it 'defines expected proxy params and methods' do
    expect(described_class.proxy_param_def).to eq(nil)
    expect(described_class.proxy_methods).to eq(expected_proxy_methods)
  end
end

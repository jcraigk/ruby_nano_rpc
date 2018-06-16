# frozen_string_literal: true
require 'spec_helper'

RSpec.describe NanoRpc::Wallet do
  subject { described_class.new(seed) }
  let(:seed) { 'E929FBC3' }
  let(:expected_proxy_methods) do
    %i[
      account_create
      account_list
      account_remove
      accounts_create
      password_change
      password_enter
      password_valid
      payment_begin
      payment_end
      payment_init
      receive
      search_pending
      send
      wallet_add
      wallet_add_watch
      wallet_balance_total
      wallet_balances
      wallet_change_seed
      wallet_contains
      wallet_destroy
      wallet_export
      wallet_frontiers
      wallet_ledger
      wallet_locked
      wallet_pending
      wallet_representative
      wallet_representative_set
      wallet_republish
      wallet_work_get
      work_get
      work_set
    ]
  end
  let(:expected_proxy_params) { { wallet: :seed } }

  it 'defines expected proxy params and methods' do
    expect(described_class.proxy_param_def).to eq(expected_proxy_params)
    expect(described_class.proxy_methods).to eq(expected_proxy_methods)
  end

  it 'raises MissingParameters unless initialized with string' do
    expect { described_class.new }.to raise_error(
      NanoRpc::MissingParameters, 'Missing argument: seed (str)'
    )
  end

  it 'assigns seed on initialization' do
    expect(subject.seed).to eq(seed)
  end

  it 'obscures seed in #inspect output' do
    expect(subject.inspect).to_not include('@seed')
  end

  context 'when changing the remote seed' do
    let(:new_seed) { 'abcdef' }

    before do
      allow_any_instance_of(NanoRpc::Node).to receive(:call).and_return(
        NanoRpc::Response.new('success' => '')
      )
    end

    it 'changes local @seed when changing remote seed' do
      subject.wallet_change_seed(seed: new_seed)
      expect(subject.seed).to eq(new_seed)
    end
  end
end

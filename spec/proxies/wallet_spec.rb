# frozen_string_literal: true
RSpec.describe Nano::Wallet do
  subject { described_class.new(seed) }
  let(:seed) { 'E929FBC3' }
  let(:expected_proxy_methods) do
    %i[
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
      wallet_balance_total
      wallet_balances
      wallet_change_seed
      wallet_contains
      wallet_create
      wallet_destroy
      wallet_export
      wallet_frontiers
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
      Nano::MissingParameters, 'Missing argument: address (str)'
    )
  end

  it 'assigns seed on initialization' do
    expect(subject.seed).to eq(seed)
  end
end

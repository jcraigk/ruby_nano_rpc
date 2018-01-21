# frozen_string_literal: true
RSpec.describe RaiblocksRpc::Response do
  subject { described_class.new(data) }
  let(:data) { { 'balance' => balance.to_s } }
  let(:balance) { 1000 }

  it 'provides MergeInitializer with coersion' do
    expect(subject['balance']).to eq(balance)
  end

  it 'provides IndifferentAccess with coersion' do
    expect(subject[:balance]).to eq(balance)
  end

  it 'provides MethodAccess methods with coersion' do
    expect(subject.balance).to eq(balance)
  end
end

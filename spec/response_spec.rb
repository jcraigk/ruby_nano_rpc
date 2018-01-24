# frozen_string_literal: true
RSpec.describe Raiblocks::Response do
  subject { described_class.new(data) }
  let(:data) { { 'balance' => balance.to_s, 'float' => float } }
  let(:balance) { 1000 }
  let(:float) { 0.001 }

  it 'provides MergeInitializer with coersion' do
    expect(subject['balance']).to eq(balance)
  end

  it 'provides IndifferentAccess with coersion' do
    expect(subject[:balance]).to eq(balance)
  end

  it 'provides MethodAccess methods with coersion' do
    expect(subject.balance).to eq(balance)
    expect(subject.float).to eq(float)
  end
end

# frozen_string_literal: true

require 'spec_helper'

RSpec.describe NanoRpc::Response do
  subject(:response) { described_class.new(data) }

  let(:data) { { 'balance' => balance.to_s, 'float' => float } }
  let(:balance) { 1000 }
  let(:float) { 0.001 }

  it 'provides MergeInitializer with coersion' do
    expect(response['balance']).to eq(balance)
  end

  it 'provides IndifferentAccess with coersion' do
    expect(response[:balance]).to eq(balance)
  end

  describe '::Hashie::Extensions::MethodAccess methods with coercion' do
    it '#blanace' do
      expect(response.balance).to eq(balance)
    end

    it '#float' do
      expect(response.float).to eq(float)
    end
  end
end

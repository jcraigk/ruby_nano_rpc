# frozen_string_literal: true
require 'spec_helper'

RSpec.describe 'Numeric conversion monkeypatching' do
  let(:valid_raw) do
    52_343_023_431_000_000_000_000_000_000_000_000
  end
  let(:invalid_raw) { 100_000_000 } # too small
  let(:valid_nano) { 52_343.0234319 }
  let(:invalid_nano) { 100_000_000_000_000 } # too large

  context '#to_nano' do
    it 'converts valid raw amounts' do
      expect(valid_raw.to_nano).to eq(52_343.023431)
    end

    it 'raises error on invalid raw amounts' do
      expect { invalid_raw.to_nano }.to raise_error(NanoRpc::InvalidRawAmount)
    end
  end

  context '#to_raw' do
    it 'converts valid nano amounts' do
      expect(valid_nano.to_raw).to eq(valid_raw)
    end

    it 'raises error on invalid nano amounts' do
      expect { invalid_nano.to_raw }.to raise_error(NanoRpc::InvalidNanoAmount)
    end
  end
end

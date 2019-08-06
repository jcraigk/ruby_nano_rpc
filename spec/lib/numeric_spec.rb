# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Numeric do
  let(:valid_raw) do
    52_343_023_431_000_000_000_000_000_000_000_000
  end
  let(:invalid_raw) { 100_000_000 } # too small
  let(:valid_nano) { 52_343.0234319 }
  let(:invalid_nano) { 100_000_000_000_000 } # too large
  let(:zero) { 0 }

  describe '#to_nano monkeypatch' do
    it 'converts valid raw amount' do
      expect(valid_raw.to_nano).to eq(52_343.023431)
    end

    it 'converts zero' do
      expect(zero.to_nano).to eq(0.0)
    end

    it 'raises error on invalid raw amounts' do
      expect { invalid_raw.to_nano }.to raise_error(NanoRpc::InvalidRawAmount)
    end
  end

  describe '#to_raw monkeypatch' do
    it 'converts valid nano amount' do
      expect(valid_nano.to_raw).to eq(valid_raw)
    end

    it 'converts zero' do
      expect(zero.to_raw).to eq(0)
    end

    it 'raises error on invalid nano amounts' do
      expect { invalid_nano.to_raw }.to raise_error(NanoRpc::InvalidNanoAmount)
    end
  end
end

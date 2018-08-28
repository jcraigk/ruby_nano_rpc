# frozen_string_literal: true
module NanoRpc
  RAW_FACTOR = 30
  RAW_PRECISION = 6

  module NanoToRaw
    def to_raw
      ensure_valid_nano_amount
      (self * 10**RAW_PRECISION).floor *
        10**(RAW_FACTOR - RAW_PRECISION)
    end

    private

    def ensure_valid_nano_amount
      raise NanoRpc::InvalidNanoAmount unless valid_nano_amount?
    end

    # 133,248,290 total nano in circulation
    def valid_nano_amount?
      self <= 133_248_290
    end
  end

  module RawToNano
    def to_nano
      ensure_valid_raw_amount
      (to_f / 10**RAW_FACTOR).round(RAW_PRECISION)
    end

    private

    def ensure_valid_raw_amount
      raise NanoRpc::InvalidRawAmount unless valid_raw_amount?
    end

    # Ensure at least 10^23
    def valid_raw_amount?
      zero? || self >= 100_000_000_000_000_000_000_000
    end
  end
end

class Numeric
  include NanoRpc::NanoToRaw
  include NanoRpc::RawToNano
end

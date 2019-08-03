# frozen_string_literal: true

module NanoRpc
  # General app helpers
  module ApplicationHelper
    private

    def inspect_prefix
      "#<#{self.class}:#{obj_id}"
    end

    def obj_id
      format('0x00%<object_id>x', object_id: object_id << 1)
    end
  end
end

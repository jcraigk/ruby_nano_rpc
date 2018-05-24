# frozen_string_literal: true
module NanoRpc::ApplicationHelper
  private

  def inspect_prefix
    "#<#{self.class}:#{format('0x00%x', object_id << 1)}"
  end
end

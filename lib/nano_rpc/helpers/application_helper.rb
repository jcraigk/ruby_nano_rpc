# frozen_string_literal: true
module Nano::ApplicationHelper
  private

  def opts_pluck(opts, key)
    opts.is_a?(Hash) ? opts[key] : opts
  end
end

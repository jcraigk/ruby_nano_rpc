# frozen_string_literal: true
require 'spec_helper'

RSpec.describe NanoRpc do
  it 'has a version number' do
    expect(NanoRpc::VERSION).not_to be(nil)
  end
end

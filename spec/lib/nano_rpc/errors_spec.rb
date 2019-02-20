# frozen_string_literal: true
require 'spec_helper'

RSpec.describe NanoRpc::Error do
  it { is_expected.to be_a(StandardError) }

  shared_examples 'child error' do
    it { is_expected.to be_a(described_class) }
  end

  describe NanoRpc::BadRequest do
    include_examples 'child error'
  end

  describe NanoRpc::ForbiddenParameter do
    include_examples 'child error'
  end

  describe NanoRpc::InvalidNanoAmount do
    include_examples 'child error'
  end

  describe NanoRpc::InvalidRawAmount do
    include_examples 'child error'
  end

  describe NanoRpc::InvalidRequest do
    include_examples 'child error'
  end

  describe NanoRpc::MissingParameters do
    include_examples 'child error'
  end

  describe NanoRpc::NodeConnectionFailure do
    include_examples 'child error'
  end

  describe NanoRpc::NodeTimeout do
    include_examples 'child error'
  end
end

# frozen_string_literal: true
require 'spec_helper'

RSpec.describe 'Nano errors' do
  describe NanoRpc::Error do
    it 'is a StandardError' do
      expect(subject).to be_a(StandardError)
    end
  end

  shared_examples 'child error' do
    it 'is a NanoRpc::Error' do
      expect(subject).to be_a(NanoRpc::Error)
    end
  end

  describe NanoRpc::BadRequest do
    include_examples 'child error'
  end
  describe NanoRpc::InvalidRequest do
    include_examples 'child error'
  end
  describe NanoRpc::ForbiddenParameter do
    include_examples 'child error'
  end
  describe NanoRpc::MissingParameters do
    include_examples 'child error'
  end
end

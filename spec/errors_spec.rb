# frozen_string_literal: true
require 'spec_helper'

RSpec.describe 'Raiblocks errors' do
  describe Raiblocks::Error do
    it 'is a StandardError' do
      expect(subject).to be_a StandardError
    end
  end

  shared_examples 'child error' do
    it 'is a Raiblocks::Error' do
      expect(subject).to be_a Raiblocks::Error
    end
  end

  describe Raiblocks::BadRequest do
    include_examples 'child error'
  end
  describe Raiblocks::InvalidRequest do
    include_examples 'child error'
  end
  describe Raiblocks::InvalidParameterType do
    include_examples 'child error'
  end
  describe Raiblocks::ForbiddenParameter do
    include_examples 'child error'
  end
  describe Raiblocks::MissingParameters do
    include_examples 'child error'
  end
end

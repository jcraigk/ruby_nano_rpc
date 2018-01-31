# frozen_string_literal: true
require 'spec_helper'

RSpec.describe 'Nano errors' do
  describe Nano::Error do
    it 'is a StandardError' do
      expect(subject).to be_a StandardError
    end
  end

  shared_examples 'child error' do
    it 'is a Nano::Error' do
      expect(subject).to be_a Nano::Error
    end
  end

  describe Nano::BadRequest do
    include_examples 'child error'
  end
  describe Nano::InvalidRequest do
    include_examples 'child error'
  end
  describe Nano::InvalidParameterType do
    include_examples 'child error'
  end
  describe Nano::ForbiddenParameter do
    include_examples 'child error'
  end
  describe Nano::MissingParameters do
    include_examples 'child error'
  end
end

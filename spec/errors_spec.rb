require 'spec_helper'

RSpec.describe 'RaiblocksRpc errors' do
  describe RaiblocksRpc::Error do
    it 'is a StandardError' do
      expect(subject).to be_a StandardError
    end
  end

  shared_examples 'child error' do
    it 'is a RaiblocksRpc::Error' do
      expect(subject).to be_a RaiblocksRpc::Error
    end
  end

  describe RaiblocksRpc::BadRequest do
    include_examples 'child error'
  end
  describe RaiblocksRpc::InvalidRequest do
    include_examples 'child error'
  end
  describe RaiblocksRpc::InvalidParameterType do
    include_examples 'child error'
  end
  describe RaiblocksRpc::ForbiddenParameter do
    include_examples 'child error'
  end
  describe RaiblocksRpc::MissingParameters do
    include_examples 'child error'
  end
end

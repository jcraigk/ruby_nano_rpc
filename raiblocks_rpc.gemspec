# frozen_string_literal: true
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'raiblocks_rpc/version'

Gem::Specification.new do |spec|
  spec.name          = 'raiblocks_rpc'
  spec.version       = RaiblocksRpc::VERSION
  spec.authors       = ['Justin Craig-Kuhn (JCK)']
  spec.email         = ['jcraigk@gmail.com']

  spec.summary       = 'An RPC wrapper for RaiBlocks written in Ruby'
  spec.description   = 'An RPC wrapper for RaiBlocks written in Ruby'
  spec.homepage      = 'https://raiblocks.net'
  spec.license       = 'MIT'

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'pry', '~> 0.11.3'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'simplecov', '~> 0.15.1'
  spec.add_development_dependency 'rubocop', '~> 0.52.1'

  spec.add_runtime_dependency 'hashie', '~> 3.5.7'
  spec.add_runtime_dependency 'rest-client', '~> 2.0.2'
end

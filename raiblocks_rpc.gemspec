# frozen_string_literal: true
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'raiblocks/version'

Gem::Specification.new do |spec|
  spec.name          = 'raiblocks_rpc'
  spec.version       = Raiblocks::VERSION
  spec.authors       = ['Justin Craig-Kuhn (JCK)']
  spec.email         = ['jcraigk@gmail.com']

  spec.summary       = 'RPC wrapper for RaiBlocks nodes written in Ruby'
  spec.description   = 'An RPC wrapper for RaiBlocks nodes written in Ruby.' \
                       'It connects to an individual node that you control. ' \
                       "There's a client object you can use to make explicit " \
                       'RPC calls as well as proxy objects with logically ' \
                       'grouped methods.'
  spec.homepage      = 'https://github.com/jcraigk/ruby_raiblocks_rpc'
  spec.license       = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = %w[lib]

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'pry', '~> 0.11.3'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.52.1'
  spec.add_development_dependency 'simplecov', '~> 0.15.1'

  spec.add_runtime_dependency 'hashie', '~> 3.5', '>= 3.5.7'
  spec.add_runtime_dependency 'rest-client', '~> 2.0', '>= 2.0.2'
end

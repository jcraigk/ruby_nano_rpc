# frozen_string_literal: true
lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nano_rpc/version'

Gem::Specification.new do |spec|
  spec.name          = 'nano_rpc'
  spec.version       = NanoRpc::VERSION
  spec.authors       = ['Justin Craig-Kuhn (JCK)']
  spec.email         = ['jcraigk@gmail.com']

  spec.summary       = 'RPC wrapper for Nano digital nodes written in Ruby'
  spec.description   = 'An RPC wrapper for Nano digital currency nodes. ' \
                       'Arbitrary RPC access is provided along with proxy ' \
                       'objects that expose helper methods.'
  spec.homepage      = 'https://github.com/jcraigk/ruby_nano_rpc'
  spec.license       = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = %w[lib]

  spec.add_development_dependency 'bundler', '~> 2.0.2'
  spec.add_development_dependency 'codecov', '~> 0.1.14'
  spec.add_development_dependency 'pry', '~> 0.12.2'
  spec.add_development_dependency 'rake', '~> 12.3.2'
  spec.add_development_dependency 'rspec', '~> 3.8.0'
  spec.add_development_dependency 'rubocop', '~> 0.72.0'
  spec.add_development_dependency 'rubocop-rspec', '~> 1.33.0'
  spec.add_development_dependency 'simplecov', '~> 0.17.0'
  spec.add_development_dependency 'simplecov-rcov', '~> 0.2.3'

  spec.add_runtime_dependency 'hashie', '~> 3.6', '>= 3.6.0'
  spec.add_runtime_dependency 'http', '~> 4.1.1', '>= 4.0.5'
end

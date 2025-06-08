# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'validated_object/version'

Gem::Specification.new do |spec|
  spec.required_ruby_version = '>= 3.1'

  spec.name          = 'validated_object'
  spec.version       = ValidatedObject::VERSION
  spec.authors       = ['Robb Shecter']
  spec.email         = ['robb@public.law']

  spec.summary       = 'Self-validating plain Ruby objects.'
  spec.description   = 'A small wrapper around ActiveModel Validations.'
  spec.homepage      = 'https://github.com/public-law/validated_object'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'rake', '>= 12.3.3'
  spec.add_development_dependency 'rspec', '>= 3.9.0'
  spec.add_development_dependency 'sorbet', '>= 0.5.5890'

  spec.add_runtime_dependency 'activemodel', '>= 3.2.21'
  spec.add_runtime_dependency 'sorbet-runtime', '>= 0.5.5890'
end

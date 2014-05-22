# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'compo/version'
require 'English'

Gem::Specification.new do |spec|
  spec.name          = 'compo'
  spec.version       = Compo::VERSION
  spec.authors       = ['Matt Windsor']
  spec.email         = ['matt.windsor@ury.org.uk']
  spec.description   = %q(
    Compo provides mixins and classes that assist in implementing a variant of
    the Composite design pattern, in which each child has an ID that uniquely
    identifies it inside the parent's child set.
  )
  spec.summary       = 'Composite pattern style mixins with IDs'
  spec.homepage      = 'http://github.com/CaptainHayashi/compo'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)\//)
  spec.require_paths = ['lib']

  spec.add_development_dependency 'backports'
  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'fuubar'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '>= 3.0.0.rc1', '<4'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'yard'
  spec.add_development_dependency 'yardstick'
end

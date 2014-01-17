# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sms_tools/version'

Gem::Specification.new do |spec|
  spec.name          = 'smstools'
  spec.version       = SmsTools::VERSION
  spec.authors       = ['Dimitar Dimitrov']
  spec.email         = ['me@ddimitrov.name']
  spec.summary       = 'Small library of classes for common SMS-related functionality.'
  spec.description   = 'Features SMS text encoding detection, length counting, concatenation detection and more. Can be used with or without Rails. Requires Ruby 1.9 or newer.'
  spec.homepage      = 'https://github.com/mitio/smstools'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'minitest-ansi'
end

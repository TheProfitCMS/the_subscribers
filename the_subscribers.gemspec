# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "the_subscribers/version"

Gem::Specification.new do |spec|
  spec.name          = "the_subscribers"
  spec.version       = TheSubscribers::VERSION
  spec.authors       = ["Ilya N. Zykin"]
  spec.email         = ["zykin-ilya@ya.ru"]
  spec.summary       = %q{TheSubscribers - collect and manage of Subscribers}
  spec.description   = %q{Collect and manage of Subscribers}
  spec.homepage      = "http://github.com/the-teacher/the_subscribers"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'state_machine'
  spec.add_dependency 'encryptor'
  spec.add_dependency 'haml'

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end

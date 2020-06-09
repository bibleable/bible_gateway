# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bible_gateway/version'

Gem::Specification.new do |spec|
  spec.name          = "bible_gateway"
  spec.version       = BibleGateway::VERSION
  spec.authors       = ["Geoffrey Dagley"]
  spec.email         = ["gdagley@gmail.com", "bibleableproject@gmail.com"]
  spec.description   = %q{An unofficial 'API' for BibleGateway.com.}
  spec.summary       = %q{An unofficial 'API' for BibleGateway.com.}
  spec.homepage      = "https://github.com/gdagley/bible_gateway"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "nokogiri", "1.10.9"
  spec.add_dependency "typhoeus", "1.4.0"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", "13.0.1"
  spec.add_development_dependency "rspec", "3.9.0"
end

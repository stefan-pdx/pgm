# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pgm/version'

Gem::Specification.new do |spec|
  spec.name          = "pgm"
  spec.version       = PGM::VERSION
  spec.authors       = ["Stefan Novak"]
  spec.email         = ["stefan.louis.novak@gmail.com"]
  spec.description   = %q{A collection of Ruby DSLs for probabilistic graphical models}
  spec.summary       = %q{Inspired by the Probabilistic Graphical Models course by Coursera, this is a gem containing several DSLs that make it easier to express data structures pertaining to graphical models.}
  spec.homepage      = "https://github.com/slnovak/pgm"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.13.0"
end

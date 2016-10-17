# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rail_grinder/version'

Gem::Specification.new do |spec|
  spec.name          = "rail_grinder"
  spec.version       = RailGrinder::VERSION
  spec.authors       = ["Steve Halasz"]
  spec.email         = ["stevehalasz@gmail.com"]

  spec.summary       = "Interrogate and update the version of a gem used by a fleet of apps"
  spec.homepage      = "https://gitlab.com/lycoperdon/rail_grinder"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rugged"

  spec.add_development_dependency "awesome_print"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end

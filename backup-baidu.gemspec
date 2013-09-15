# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'backup/baidu/version'

Gem::Specification.new do |spec|
  spec.name          = "backup-baidu"
  spec.version       = Backup::Baidu::VERSION
  spec.authors       = ["DylanDeng"]
  spec.email         = ["dylan@beansmile.com"]
  spec.description   = %q{TODO: Write a gem description}
  spec.summary       = %q{TODO: Write a gem summary}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  s.add_dependency "backup", ">= 3.7.0"
  s.add_dependency "api4baidu", ">=0.1.1"
  s.add_dependency "oauth2", ["~> 0.9.2"]
  s.add_dependency "json", ["~> 1.8.0"]
end

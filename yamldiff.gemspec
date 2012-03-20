# -*- encoding: utf-8 -*-
require File.expand_path('../lib/yamldiff/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Jonathan R. Wallace"]
  gem.email         = ["jonathan.wallace@gmail.com"]
  gem.description   = %q{Shows the difference yaml keys}
  gem.summary       = %q{Yamldiff will tell you when and where you have differences between two yaml files.  It prints out a list of missing keys for the second file.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "yamldiff"
  gem.require_paths = ["lib"]
  gem.version       = Yamldiff::VERSION
  gem.add_development_dependency 'fakefs'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
end

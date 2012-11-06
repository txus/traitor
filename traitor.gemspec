# -*- encoding: utf-8 -*-
require File.expand_path('../lib/traitor/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Josep M. Bach"]
  gem.email         = ["josep.m.bach@gmail.com"]
  gem.description   = %q{Traits for Ruby: like mixins, but better}
  gem.summary       = %q{Traits for Ruby: like mixins, but better}
  gem.homepage      = "https://github.com/txus/traitor"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "traitor"
  gem.require_paths = ["lib"]
  gem.version       = Traitor::VERSION
end

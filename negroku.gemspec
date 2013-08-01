# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'negroku/version'

Gem::Specification.new do |gem|
  gem.name          = "negroku"
  gem.version       = Negroku::VERSION
  gem.authors       = ["Juan Ignacio Donoso"]
  gem.email         = ["jidonoso@gmail.com"]
  gem.description   = ["To deploy application"]
  gem.summary       = ["Capistrano Wrapper"]
  gem.homepage      = "http://github.com/platanus-repos/negroku"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = ['negroku']
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency('capistrano', ['>= 3.0.0.pre13'])
  gem.add_dependency('rainbow', ['>= 1.1.4'])
  gem.add_dependency('highline', ['>= 1.6.15'])
  gem.add_dependency('thor', ['>= 0.17.0'])
end

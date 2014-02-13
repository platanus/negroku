# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'negroku/version'

Gem::Specification.new do |gem|
  gem.name          = "negroku"
  gem.version       = Negroku::VERSION
  gem.authors       = ["Juan Ignacio Donoso"]
  gem.email         = ["jidonoso@gmail.com"]
  gem.description   = ["Negroku is an opinionated collection of recipes for capistrano, blended with a handy CLI"]
  gem.summary       = ["The goal is to be able to deploy ruby on rails applications and static websites without the hassle of configuring and defining all the stuff involved in an application deployment."]
  gem.homepage      = "http://github.com/platanus/negroku"
  gem.licenses      = ['MIT']

  gem.files         = Dir['{bin,lib,setup}/**/*', 'README.md', 'LICENSE']
  gem.executables   = ['negroku']
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency('capistrano', ['~> 2.15.4'])
  gem.add_dependency('capistrano-unicorn', ['~> 0.1.9'])
  gem.add_dependency('rainbow', ['1.1.4'])
  gem.add_dependency('highline', ['>= 1.6.15'])
  gem.add_dependency('thor', ['>= 0.17.0'])
end

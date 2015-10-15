# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','negroku','version.rb'])

spec = Gem::Specification.new do |s|
  s.name = 'negroku'
  s.version = Negroku::VERSION
  s.author = 'Juan Ignacio Donoso'
  s.email = 'jidonoso@gmail.com'
  s.homepage = 'http://github.com/platanus/negroku'
  s.platform = Gem::Platform::RUBY
  s.summary = 'Capistrano recipes collection'
  s.description = 'Deploy applications right out of the box using nginx, unicorn, bower, rails, etc'

  s.files = `git ls-files`.split($/)
  s.require_paths << 'lib'
  s.bindir = 'bin'
  s.executables << 'negroku'

  s.add_development_dependency('rdoc')
  s.add_development_dependency('rspec')
  s.add_development_dependency('fakefs')

  s.add_runtime_dependency('rake', '~> 10.1')
  s.add_runtime_dependency('bundler', '~> 1.0')
  s.add_runtime_dependency('activesupport', '~> 3.0')
  s.add_runtime_dependency('capistrano', '~> 3.4.0')
  s.add_runtime_dependency('capistrano-rbenv', '~> 2.0.3')
  s.add_runtime_dependency('capistrano-rails', '~> 1.1.3')
  s.add_runtime_dependency('capistrano-bundler', '~> 1.1.4')
  s.add_runtime_dependency('capistrano-npm', '~> 1.0.1')
  s.add_runtime_dependency('capistrano-nc', '~> 0.1.4')
  s.add_runtime_dependency('capistrano-github', '~> 0.1.1')
  s.add_runtime_dependency('capistrano-rails-console', '~> 0.5.2')

  s.add_runtime_dependency('capistrano-nodenv', '~> 1.0.1')
  s.add_runtime_dependency('capistrano-bower', '~> 1.1.0')
  s.add_runtime_dependency('capistrano3-nginx', '~> 2.1.2')
  s.add_runtime_dependency('capistrano3-unicorn', '~> 0.2.1')
  s.add_runtime_dependency('capistrano3-puma', '~> 1.2.1')
  s.add_runtime_dependency('capistrano3-delayed-job', '~> 1.4.0')
  s.add_runtime_dependency('whenever', '~> 0.9.4')

  s.add_runtime_dependency('gli','~> 2.12.2')
  s.add_runtime_dependency('gems','~> 0.8.3')
  s.add_runtime_dependency('semantic','~> 1.4.1')
  s.add_runtime_dependency('inquirer','~> 0.2.1')
  s.add_runtime_dependency('virtus', '~> 1.0.5')
  s.add_runtime_dependency('i18n')
end

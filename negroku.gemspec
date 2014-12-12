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
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc','negroku.rdoc']
  s.rdoc_options << '--title' << 'negroku' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'negroku'

  s.add_development_dependency('rdoc')

  s.add_runtime_dependency('rake', '~> 10.1.0')
  s.add_runtime_dependency('capistrano','~> 3.3.0')
  s.add_runtime_dependency('capistrano-rbenv', '~> 2.0.0')
  s.add_runtime_dependency('capistrano-rails', '~> 1.1.0')
  s.add_runtime_dependency('capistrano-bundler', '~> 1.1.0')
  s.add_runtime_dependency('capistrano-nc', '~> 0.1.0')

  s.add_runtime_dependency('capistrano-nodenv', '~> 1.0.0')
  s.add_runtime_dependency('capistrano-bower', '~> 1.0.0')
  s.add_runtime_dependency('capistrano3-nginx', '~> 2.0.0')
  s.add_runtime_dependency('capistrano3-unicorn', '~> 0.1.0')
  s.add_runtime_dependency('capistrano-npm', '~> 1.0.0')

  s.add_runtime_dependency('gli','~> 2.12.0')
  s.add_runtime_dependency('rainbow','~> 2.0.0')
  s.add_runtime_dependency('inquirer','~> 0.2.0')
  s.add_runtime_dependency('i18n','~> 0.6.11')
end

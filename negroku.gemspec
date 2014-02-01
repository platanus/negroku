# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','negroku','version.rb'])
spec = Gem::Specification.new do |s|
  s.name = 'negroku'
  s.version = Negroku::VERSION
  s.author = 'Juan Ignacio Donoso'
  s.email = 'jidonoso@gmail.com'
  s.homepage = 'http://github.com/platanus/negroku'
  s.platform = Gem::Platform::RUBY
  s.summary = 'Capistrano receipes collection'

  s.files = `git ls-files`.split($/)
  s.require_paths << 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc','negroku.rdoc']
  s.rdoc_options << '--title' << 'negroku' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'negroku'

  s.add_development_dependency('rake')
  s.add_development_dependency('rdoc')
  s.add_development_dependency('aruba')

  s.add_runtime_dependency('gli','2.9.0')
  s.add_runtime_dependency('capistrano','3.1.0')
  s.add_runtime_dependency('rainbow','2.0.0')
  s.add_runtime_dependency('highline','1.6.20')
end

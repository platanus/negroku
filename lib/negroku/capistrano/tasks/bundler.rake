## bundler.rb
#
# Adds capistrano/bundler specific properties and tasks

namespace :load do
  task :defaults do

    # Set bundler to run with the --deployment flag
    set :bundle_flags, '--deployment'

  end
end

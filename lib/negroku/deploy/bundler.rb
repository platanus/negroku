## bundler.rb
#
# Adds capistrano/bundler specific properties and tasks

# Set bundler to run with the --deployment flag
set :bundle_flags, '--deployment'

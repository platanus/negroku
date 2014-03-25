# Base configuration
set :scm, :git

# set :format, :pretty
# set :log_level, :debug
set :pty, true

set :keep_releases, 5

require 'negroku/helpers'
load_deploy "rbenv"     if was_required? 'capistrano/rbenv'
load_deploy "nodenv"    if was_required? 'capistrano/nodenv'
load_deploy "bower"     if was_required? 'capistrano/bower'
load_deploy "bundler"   if was_required? 'capistrano/bundler'
load_deploy "unicorn"   if was_required? 'capistrano3/unicorn'

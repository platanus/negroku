# Base configuration
set :scm, :git

# set :format, :pretty
# set :log_level, :debug
set :pty, true

set :keep_releases, 5

require 'negroku/helpers'
load_task "rbenv"     if was_required? 'capistrano/rbenv'
load_task "nodenv"    if was_required? 'capistrano/nodenv'
load_task "bower"     if was_required? 'capistrano/bower'
load_task "bundler"   if was_required? 'capistrano/bundler'
load_task "nginx"     if was_required? 'capistrano/nginx'
load_task "unicorn"   if was_required? 'capistrano3/unicorn'

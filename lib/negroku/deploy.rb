require 'negroku/helpers'

# Base configuration
namespace :load do
  task :defaults do

    set :scm, :git

    set :format, :simple
    set :log_level, :info
    set :pty, true

    set :keep_releases, 5
  end
end

# Load Negroku tasks
load_task "negroku"
load_task "rbenv"     if was_required? 'capistrano/rbenv'
load_task "nodenv"    if was_required? 'capistrano/nodenv'
load_task "bower"     if was_required? 'capistrano/bower'
load_task "bundler"   if was_required? 'capistrano/bundler'
load_task "rails"     if was_required? 'capistrano/rails'
load_task "nginx"     if was_required? 'capistrano/nginx'
load_task "unicorn"   if was_required? 'capistrano3/unicorn'
load_task "delayed_job"   if was_required? 'capistrano/delayed-job'

load_task "log"

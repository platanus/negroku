require 'negroku/helpers'

# Base configuration
namespace :load do
  task :defaults do

    set :scm, :git

    set :format, :pretty
    set :log_level, :debug
    set :pty, true

    set :keep_releases, 5
  end
end

# Load Negroku tasks
load_task "negroku"
load_task "rbenv"     if required? 'capistrano/rbenv'
load_task "nodenv"    if required? 'capistrano/nodenv'
load_task "bower"     if required? 'capistrano/bower'
load_task "bundler"   if required? 'capistrano/bundler'
load_task "rails"     if required? 'capistrano/rails'
load_task "nginx"     if required? 'capistrano/nginx'
load_task "unicorn"   if required? 'capistrano3/unicorn'
load_task "delayed_job"   if required? 'capistrano/delayed-job'
load_task "whenever"  if required? 'whenever/capistrano'
load_task "eye"       if any_required? ['negroku/eye','capistrano3/unicorn','capistrano/delayed-job']
load_task "log"

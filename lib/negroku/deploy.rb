# Base configuration
set :scm, :git

# set :format, :pretty
# set :log_level, :debug
set :pty, true

set :keep_releases, 5

# Ensure the folders needed exist
namespace :negroku do
  namespace :deploy do
    desc "Setup the application system requirements"
    task :setup do
      if was_required? 'capistrano/nginx'
        invoke 'nginx:site:add'
        invoke 'nginx:site:enable'
        invoke 'nginx:reload'
      end

      invoke 'negroku:unicorn:restart' if was_required? 'capistrano3/unicorn'

    end
  end
end

require 'negroku/helpers'
load_deploy "rbenv"     if was_required? 'capistrano/rbenv'
load_deploy "nodenv"    if was_required? 'capistrano/nodenv'
load_deploy "bower"     if was_required? 'capistrano/bower'
load_deploy "bundler"   if was_required? 'capistrano/bundler'
load_deploy "unicorn"   if was_required? 'capistrano3/unicorn'

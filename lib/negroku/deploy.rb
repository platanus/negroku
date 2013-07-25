##
# Load Deployer Helpers
require File.join(File.dirname(__FILE__), 'helpers')

# Base settings
set   :scm,                 'git'
set   :deploy_via, :remote_cache
set   :use_sudo,            false

##
# Default Configuration
set :remote, 'origin' unless respond_to?(:remote)
set :branch, 'master' unless respond_to?(:branch)

# Default environment
set :rails_env, 'production' unless respond_to?(:rails_env)

## Default path
set :default_environment, {
  'PATH' => "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$HOME/.nodenv/shims:$HOME/.nodenv/bin:$PATH"
}

# Run on Linux: `$ ssh-add` or on OSX: `$ ssh-add -K` for "forward_agent".
ssh_options[:forward_agent] = true
ssh_options[:port]          = 22
default_run_options[:pty]   = true

# Use the bundler capistrano task to deploy to the shared folder
require "bundler/capistrano"
set :bundle_flags,    "--deployment --binstubs"

##
# Load Deployment Tasks
load_tasks('base')
load_tasks('log')
load_tasks('rbenv')
load_tasks('bower')
load_tasks('nginx')
load_tasks('unicorn')

##
# Load Deployer Helpers
require File.join(File.dirname(__FILE__), 'helpers')

set   :scm,                 'git'
set   :deploy_via, :remote_cache
set   :use_sudo,            false

##
# Default Configuration
set :remote, 'origin' unless respond_to?(:remote)
set :branch, 'master' unless respond_to?(:branch)

## Default path
set :default_environment, {
  'PATH' => "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"
}

# Run on Linux: `$ ssh-add` or on OSX: `$ ssh-add -K` for "forward_agent".
ssh_options[:forward_agent] = true
ssh_options[:port]          = 22
default_run_options[:pty]   = true

##
# Load Deployment Tasks
load_tasks('base')
load_tasks('log')
load_tasks('rbenv')
load_tasks('nginx')
load_tasks('unicorn')
# Base configuration
set :scm, :git

# set :format, :pretty
# set :log_level, :debug
set :pty, true

set :keep_releases, 5 unless respond_to?(:keep_releases)

# Load additional configuration
load File.join(File.dirname(__FILE__), 'deploy', "rbenv.rb")

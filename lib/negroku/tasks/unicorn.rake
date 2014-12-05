## unicorn.rb
#
# Adds unicorn variables and tasks
# Unicorn main tasks are taken from the gem capistrano3-unicorn

# Here we are setting up the main negroku default to work with unicorn
namespace :load do
  task :defaults do
    # Add unicorn to :rbenv_map_bins
    fetch(:rbenv_map_bins) << 'unicorn'

    ###################################
    ## capistrano3/unicorn variables

    # Defines where the unicorn pid will live.
    set :unicorn_pid, -> { "#{shared_path}/tmp/pids/unicorn.pid" }

    set :unicorn_config_path, -> { "#{shared_path}/config/unicorn.rb" }

    ###################################
    ## unicorn.rb template variables

    # Local path to look for custom config template
    set :unicorn_template, -> { "config/deploy/#{fetch(:stage)}/unicorn.rb.erb" }

    # The type of template to use
    # rails, rails_activerecord
    set :unicorn_template_type, -> { "rails_activerecord" }

    # Number of workers (Rule of thumb is 2 per CPU)
    # Just be aware that every worker needs to cache all classes and thus eat some
    # of your RAM.
    set :unicorn_workers, -> { 1 }

    # Workers timeout in the amount of seconds below, when the master kills it and
    # forks another one.
    set :unicorn_workers_timeout, -> { 30 }

    # The location of the unicorn socket
    set :unicorn_socket, -> { "#{shared_path}/tmp/sockets/unicorn.sock" }

    # Preload app for fast worker spawn
    set :unicorn_preload, -> { true }

    ###################################
    ## capistrano3/nginx variables

    # Set the app server socket if nginx is being used
    set :app_server_socket, -> { fetch(:unicorn_socket) } if was_required? 'capistrano/nginx'

  end
end

# Adds some task on complement the capistrano3-unicorn tasks
# This tasks are under the negroku namespace for easier identification
namespace :negroku do

  namespace :unicorn do
    desc "Upload unicorn configuration file"
    task :setup do
      on release_roles fetch(:unicorn_roles) do
        within "#{shared_path}/config" do
          config_file = fetch(:unicorn_template)
          unless File.exists?(config_file)
            config_file = File.expand_path("../../templates/tasks/unicorn_#{fetch(:unicorn_template_type)}.rb.erb", __FILE__)
          end
          config = ERB.new(File.read(config_file)).result(binding)
          upload! StringIO.new(config), '/tmp/unicorn.rb'

          execute :mv, '/tmp/unicorn.rb', 'unicorn.rb'
        end
      end
    end

    # Reload or restart unicorn after the application is published
    after 'deploy:publishing', 'restart' do
      invoke 'negroku:unicorn:setup'
      invoke fetch(:unicorn_preload)? 'unicorn:restart' : 'unicorn:reload'
    end

    # Ensure the folders needed exist
    after 'deploy:check', 'deploy:check:directories' do
      on release_roles fetch(:unicorn_roles) do
        execute :mkdir, '-pv', "#{shared_path}/config"
        execute :mkdir, '-pv', "#{shared_path}/tmp/sockets"
        execute :mkdir, '-pv', "#{shared_path}/tmp/pids"
      end
    end

  end

end

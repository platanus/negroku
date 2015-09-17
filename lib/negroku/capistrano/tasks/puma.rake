## puma.rb
#
# Adds puma variables and tasks
# Puma main tasks are taken from the gem capistrano3-puma

# Here we are setting up the main negroku default to work with puma
namespace :load do
  task :defaults do

    ###################################
    ## capistrano3/puma variables

    # Defines where the puma config will live.
    set :puma_conf, -> { "#{shared_path}/config/puma.rb" }

    # Local path to look for custom config template
    set :puma_template, -> { "config/deploy/#{fetch(:stage)}/puma.rb.erb" }

    # The type of template to use
    # rails, rails_activerecord
    set :puma_template_type, -> { "rails_activerecord" }


    # Workers timeout in the amount of seconds below, when the master kills it and
    # forks another one.
    set :puma_worker_timeout, -> { 30 }

    # The location of the puma socket
    set :puma_socket, -> { "#{shared_path}/tmp/sockets/puma.sock" }
    set :puma_bind, -> { "unix://#{fetch(:puma_socket)}" }

    # Preload app for fast worker spawn
    set :puma_preload, -> { false }

    ###################################
    ## capistrano3/nginx variables

    # Set the app server socket if nginx is being used
    set :app_server_socket, -> { fetch(:puma_socket) } if required? 'capistrano/nginx'

    ## Eye monitoring
    set :puma_master_cpu_checks, "check :cpu, :every => 30, :below => 80, :times => 3"
    set :puma_master_memory_checks, "check :memory, :every => 30, :below => 150.megabytes, :times => [3,5]"

  end
end

# Adds some task on complement the capistrano3-puma tasks
# This tasks are under the negroku namespace for easier identification
namespace :negroku do

  namespace :puma do
    desc "Upload puma configuration file"
    task :setup do
      on release_roles fetch(:puma_roles) do
        within "#{shared_path}/config" do
          template_path = fetch(:puma_template)

          # user a build in template if the template doesn't exists in the project
          unless File.exists?(template_path)
            template_path = "capistrano/templates/puma.rb.erb"
          end

          config = build_template(template_path, nil, binding)
          upload! config, '/tmp/puma.rb'

          execute :mv, '/tmp/puma.rb', 'puma.rb'
        end
      end
    end

    # Reload or restart puma after the application is published
    after 'deploy:published', 'restart' do
      invoke 'negroku:puma:setup'
      invoke 'puma:smart_restart'
    end

    define_logs(:puma, {
      error: 'puma_error.log',
      access: 'puma_access.log'
    })

  end
end

# Ensure the folders needed exist
task 'deploy:check:directories' do
  on release_roles fetch(:puma_role) do
    execute :mkdir, '-pv', "#{shared_path}/config"
    execute :mkdir, '-pv', "#{shared_path}/tmp/sockets"
    execute :mkdir, '-pv', "#{shared_path}/tmp/pids"
  end
end

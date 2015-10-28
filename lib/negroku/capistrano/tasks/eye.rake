require 'negroku/helpers/templates'
## eye.rb
#
# Adds eye variables and tasks

namespace :load do
  task :defaults do

    set :eye_roles, [:app]

    ###################################
    ## eye template variables

    # Local path to look for custom config template
    set :eye_application_template, -> { "config/deploy/#{fetch(:stage)}/eye.rb.erb" }

    # Application level notifications
    set :eye_notification_contact, -> { :monitor }
    set :eye_notification_level, -> { :error }

    set :eye_ruby_version, -> { '2.1' }

    # Add eye to :rbenv_map_bins
    fetch(:rbenv_map_bins) << 'eye'
  end
end

# namespace :env do
#   desc 'Env variables changed'
#   task :changed do
#   end
# end

namespace :eye do
  WATCHED_PROCESSES = %w[unicorn delayed_job thinking_sphinx puma]

  task :watch_process_deprecation do
    puts "\n\nWARNING:\ttask 'eye:watch_process' is deprecated."
    puts "\t\tPlease read the docs at https://github.com/platanus/negroku/blob/master/docs/TASKS.md#eye\n\n"
  end

  desc "Loads eye config and starts monitoring"
  task :load do
    on release_roles fetch(:eye_roles) do
      with rbenv_version: fetch(:eye_ruby_version) do
        within current_path do
         execute :eye, :load, "#{shared_path}/config/eye.rb"
        end
      end
    end
  end

  [:start,:restart, :info, :stop].each do |cmd|
    desc "Calls eye's #{cmd.to_s} on the whole app"
    task cmd, [:mask] do |t, args|
      on release_roles fetch(:eye_roles) do
        with rbenv_version: fetch(:eye_ruby_version) do
          within current_path do
            mask = fetch(:application)
            mask +=  ":#{args[:mask]}" if args[:mask]
            execute :eye, cmd, mask

            Rake::Task["eye:#{cmd}"].reenable
          end
        end
      end
    end
  end

  desc "Upload eye configuration file"
  task :setup do
    # DEPRECATE eye:watch_process
    begin
      Rake::Task['eye:watch_process'].enhance do
        at_exit { Rake::Task['eye:watch_process_deprecation'].invoke if $!.nil? }
      end
      Rake::Task['eye:watch_process'].invoke
    rescue StandardError
    end

    WATCHED_PROCESSES.each do |task_name|
      begin
        Rake::Task["#{task_name}:watch_process"].invoke
      rescue StandardError
      end
    end

    on release_roles fetch(:eye_roles) do
      within "#{shared_path}/config" do
        processes = fetch(:eye_watched_processes, {})

        template_path = fetch(:eye_application_template)

        # use a build in template if the template doesn't exists in the project
        unless File.exists?(template_path)
          template_path = "capistrano/templates/eye/application.eye.erb"
        end

        config = build_template(template_path, nil, binding)
        upload! config, '/tmp/application.eye'

        execute :mv, '/tmp/application.eye', 'eye.rb'
      end
    end
  end

  desc "Restart application by stoping, reloading and starting"
  task :hard_restart do
    invoke 'eye:stop'
    sleep 5
    invoke 'eye:load'
    invoke 'eye:start'
  end

  before "deploy:published", "eye:setup"
  after "eye:setup", "eye:load"

  define_logs(:eye, app: 'eye.log')
end

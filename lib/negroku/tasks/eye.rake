require 'negroku/helpers/templates'
## eye.rb
#
# Adds eye variables and tasks

namespace :load do
  task :defaults do
    ###################################
    ## eye template variables

    # Local path to look for custom config template
    set :eye_application_template, -> { "config/deploy/#{fetch(:stage)}/eye.rb.erb" }

    # Application level notifications
    set :eye_notification_contact, -> { :monitor }
    set :eye_notification_level, -> { :error }

    # Add eye to :rbenv_map_bins
    fetch(:rbenv_map_bins) << 'eye'
  end
end

namespace :env do
  desc 'Env variables changed'
  task :changed do
  end
end

namespace :eye do

  desc "Loads eye config and starts monitoring"
  task :load do
    on release_roles fetch(:eye_roles) do
      within current_path do
       execute :eye, :load, "#{shared_path}/config/eye.rb"
      end
    end
  end

  [:start,:restart, :info, :stop].each do |cmd|
    desc "Calls eye's #{cmd.to_s} on the whole app"
    task cmd, [:mask] do |t, args|
      on release_roles fetch(:eye_roles) do
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

# Adds some task on complement the capistrano3-unicorn tasks
# This tasks are under the negroku namespace for easier identification
namespace :negroku do

  namespace :eye do

    desc "Upload eye configuration file"
    task :setup => 'eye:watch_process' do
      on release_roles fetch(:eye_roles) do
        within "#{shared_path}/config" do
          processes = fetch(:eye_watched_processes, {})

          template_path = fetch(:eye_application_template)

          # use a build in template if the template doesn't exists in the project
          unless File.exists?(template_path)
            template_path = "tasks/eye/application.eye.erb"
          end

          config = build_template(template_path, nil, binding)
          upload! config, '/tmp/application.eye'

          execute :mv, '/tmp/application.eye', 'eye.rb'
        end
      end
    end

    before "deploy:published", "negroku:eye:setup"
    after "negroku:eye:setup", "eye:load"

    after 'env:changed', 'hard-restart' do
      invoke 'eye:stop'
      invoke 'eye:load'
      invoke 'eye:start'
    end

    define_logs(:eye, {
      app: 'eye.log'
    })

  end

end

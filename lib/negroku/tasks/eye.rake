## eye.rb
#
# Adds eye variables and tasks
namespace :load do
  task :defaults do
    ###################################
    ## eye template variables

    # Local path to look for custom config template
    set :eye_template, -> { "config/deploy/#{fetch(:stage)}/eye.rb.erb" }

  end
end


namespace :eye do

  desc "Loads eye config and starts monitoring"
  task :load do
    on release_roles fetch(:eye_roles) do
      within "#{current_path}" do
       execute :bundle, :exec, :eye, :load, "#{shared_path}/config/eye.rb"
      end
    end
  end

  [:start,:restart, :info, :stop].each do |cmd|
      # Single process
    desc "Calls eye's #{cmd.to_s} on a process"
    task "#{cmd}:process", [:name] do |t, args|
      on release_roles fetch(:eye_roles) do
        within "#{current_path}" do
          execute :bundle, :exec, :eye, cmd, "#{args[:name]}"
        end
      end
    end
    #
    desc "Calls eye's #{cmd.to_s} on the whole app"
    task cmd do |t, args|
      on release_roles fetch(:eye_roles) do
        within "#{current_path}" do
          execute :bundle, :exec, :eye, cmd, "#{fetch(:application)}"
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
    task :setup do
      on release_roles fetch(:eye_roles) do
        within "#{shared_path}/config" do
          processes = fetch(:eye_processes, {})

          template_path = fetch(:eye_template)

          # user a build in template if the template doesn't exists in the project
          unless File.exists?(template_path)
            template_path = "tasks/eye/eye.rb.erb"
          end

          config = build_template(template_path, nil, binding)
          upload! config, '/tmp/eye.rb'

          execute :mv, '/tmp/eye.rb', 'eye.rb'
        end
      end
    end

    before "deploy:publishing", "negroku:eye:setup"

    before "eye:setup", "eye:setup:discovery" do

      if was_required? 'capistrano3/unicorn'
            watch_process(:unicorn, fetch(:unicorn_roles), {
              pid_file: fetch(:unicorn_pid),
              stdall: fetch(:unicorn_log),
              start_command: "bundle exec unicorn -c #{shared_path}/config/unicorn.rb -E #{fetch(:stage)} -D",
              stop_command: "kill -QUIT #{fetch(:unicorn_pid)}",
              restart_command: "kill -USR2 #{fetch(:unicorn_pid)}",
              check: {
                cpu: "every: 10.seconds, below: 100, times: 3",
                memory: "every: 20.seconds, below: 700.megabytes, times: 3"
      }
    })


      end
    end

    define_logs(:eye, {
      app: 'production.log'
    })

  end

end

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
        execute "mkdir -p #{shared_path}/config/processes"
        execute "cd #{current_path} && bundle exec eye load #{shared_path}/config/eye.rb"
    end
  end

  desc "Starts monitoring"
  task :start, [:process] do |t, args|
    on release_roles fetch(:eye_roles) do
        execute "cd #{current_path} && bundle exec eye start #{args[:process]}"
    end
  end

  desc "Restarts monitoring"
  task :restart, [:process] do |t, args|
    #i.e: eye r test:samples:sample1 (source: https://github.com/kostya/eye)
    on release_roles fetch(:eye_roles) do
        execute "cd #{current_path} && bundle exec eye restart #{args[:process]}"
    end
  end

  desc "Stops monitoring"
  task :stop, [:process] do |t, args|
    on release_roles fetch(:eye_roles) do
        execute "cd #{current_path} && bundle exec eye stop #{args[:process]}"
    end
  end

  desc "Displays monitoring status"
  task :status, [:process] do |t, args|
    on release_roles fetch(:eye_roles) do 
       puts shared_path
       execute "cd #{current_path} && bundle exec eye info #{args[:process]}"
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

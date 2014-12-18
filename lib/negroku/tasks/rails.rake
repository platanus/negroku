## rails.rb
#
# Adds rails variables and tasks
# Rails main tasks are loaded from the gem capistrano-rails

namespace :load do
  task :defaults do

  end
end

namespace :rails do
  desc "Open the rails console on the primary remote app server"
  task :console do
    on roles(:app), :primary => true do |host|
      execute_interactively host, "console #{fetch(:rails_env)}"
    end
  end

  desc "Open the rails dbconsole on the primary remote app server"
  task :dbconsole do
    on roles(:app), :primary => true do |host|
      execute_interactively host, "dbconsole #{fetch(:rails_env)}"
    end
  end

  def execute_interactively(host, command)
    command = "cd #{fetch(:deploy_to)}/current && #{SSHKit.config.command_map[:bundle]} exec rails #{command}"
    puts command if fetch(:log_level) == :debug
    exec "ssh -l #{host.user} #{host.hostname} -p #{host.port || 22} -t '#{command}'"
  end
end

namespace :negroku do

  namespace :rails do

    define_logs(:rails, {
      app: 'production.log'
    })

  end

end

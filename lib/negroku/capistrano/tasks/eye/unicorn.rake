#########
## Adds support to monitor unicorn processes through eye
#########

# Watch the unicorn processes using the build in template
namespace :unicorn do
  task :watch_process do
    watch_process(:unicorn, start_timeout: fetch(:eye_puma_start_timeout, 60),
                            stop_timeout: fetch(:eye_puma_stop_timeout, 30),
                            restart_timeout: fetch(:eye_puma_restart_timeout, 30),
                            start_grace: fetch(:eye_puma_start_grace, 100),
                            stop_grace: fetch(:eye_puma_stop_grace, 30),
                            restart_grace: fetch(:eye_puma_restart_grace, 30))
  end

  # Override start, restart and stop unicorn tasks to so they call
  # the eye equivalents
  ['start', 'restart', 'stop'].each do |cmd|
    if Rake::Task.task_defined?("unicorn:#{cmd}")
      Rake::Task["unicorn:#{cmd}"].clear_actions
      # Reload or restart unicorn after the application is published
      desc "using eye"
      task cmd do
        invoke "eye:#{cmd}", 'unicorn'
      end
    end
  end
end

#########
## Adds support to monitor sphinx processes through eye
#########

# Watch the sphinx processes using the build in template
namespace :thinking_sphinx do
  task :watch_process do
    watch_process(:sphinx, start_timeout: fetch(:eye_thinking_sphinx_start_timeout, 60),
                           stop_timeout: fetch(:eye_thinking_sphinx_stop_timeout, 30),
                           restart_timeout: fetch(:eye_thinking_sphinx_restart_timeout, 30),
                           start_grace: fetch(:eye_thinking_sphinx_start_grace, 100),
                           stop_grace: fetch(:eye_thinking_sphinx_stop_grace, 30),
                           restart_grace: fetch(:eye_thinking_sphinx_restart_grace, 30))
  end

  # Override start, restart and stop sphinx tasks to so they call
  # the eye equivalents
  ['start', 'restart', 'stop'].each do |cmd|
    if Rake::Task.task_defined?("thinking_sphinx:#{cmd}")
      Rake::Task["thinking_sphinx:#{cmd}"].clear_actions
      # Reload or restart after the application is published
      desc "using eye"
      task cmd do
        invoke "eye:#{cmd}", 'sphinx'
      end
    end
  end
end

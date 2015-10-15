#########
## Adds support to monitor puma processes through eye
#########

# Watch the puma processes using the build in template
namespace :puma do
  task :watch_process do
    watch_process(:puma)
  end

  # Override start, restart and stop puma tasks to so they call
  # the eye equivalents
  ['start', 'restart', 'stop'].each do |cmd|
    if Rake::Task.task_defined?("puma:#{cmd}")
      Rake::Task["puma:#{cmd}"].clear_actions
      # Reload or restart puma after the application is published
      desc "using eye"
      task cmd do
        invoke "eye:#{cmd}", 'puma'
      end
    end
  end
end

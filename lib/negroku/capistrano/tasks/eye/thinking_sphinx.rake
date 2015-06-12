#########
## Adds support to monitor sphinx processes through eye
#########

# Watch the sphinx processes using the build in template
namespace :eye do
  task :watch_process do

    watch_process(:sphinx);

  end
end

# Override start, restart and stop sphinx tasks to so they call
# the eye equivalents
namespace :thinking_sphinx do
  ['start','restart','stop'].each do |cmd|
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

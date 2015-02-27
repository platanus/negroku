#########
## Adds support to monitor unicorn processes through eye
#########

# Watch the unicorn processes using the build in template
watch_process(:unicorn);

# Override start, restart and stop unicorn tasks to so they call
# the eye equivalents
namespace :unicorn do
  ['start','restart','stop'].each do |cmd|
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

#########
## Adds support to monitor delayed_job processes through eye
#########

# Watch the delayed_job processes using the build in template
watch_process(:delayed_job);

# Override start, restart and stop delayed_job tasks to so they call
# the eye equivalents
# namespace :unicorn do
#   ['start','restart','stop'].each do |cmd|
#     if Rake::Task.task_defined?("unicorn:#{cmd}")
#       Rake::Task["unicorn:#{cmd}"].clear_actions
#       # Reload or restart unicorn after the application is published
#       desc "#{cmd} unicorn through eye"
#       task cmd do
#         invoke "eye:#{cmd}", 'unicorn'
#       end
#     end
#   end
# end

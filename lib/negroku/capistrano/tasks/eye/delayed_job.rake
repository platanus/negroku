#########
## Adds support to monitor delayed_job processes through eye
#########

# Watch the delayed_job processes using the build in template
namespace :delayed_job do
  # Remove the multi process arg
  def delayed_job_single_args
    delayed_job_args.gsub(/-n\s\d\s*/, "")
  end

  def delayed_job_start_command
    "#{fetch(:rbenv_prefix)} bundle exec #{delayed_job_bin} #{delayed_job_single_args} -i \#{i} start"
  end

  def delayed_job_stop_command
    "#{fetch(:rbenv_prefix)} bundle exec #{delayed_job_bin} #{delayed_job_single_args} -i \#{i} stop"
  end

  task :watch_process do
    watch_process(:delayed_job, start_command: delayed_job_start_command,
                                stop_command: delayed_job_stop_command)
  end

  # Override start, restart and stop delayed_job tasks to so they call
  # the eye equivalents
  ['start', 'restart', 'stop'].each do |cmd|
    if Rake::Task.task_defined?("delayed_job:#{cmd}")
      Rake::Task["delayed_job:#{cmd}"].clear_actions
      # Reload or restart delayed_job after the application is published
      desc "using eye"
      task cmd do
        invoke "eye:#{cmd}", 'delayed-job'
      end
    end
  end
end

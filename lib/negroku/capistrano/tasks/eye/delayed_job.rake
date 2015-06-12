#########
## Adds support to monitor delayed_job processes through eye
#########
def delayed_job_args
  args = []
  args << "--queues=#{fetch(:delayed_job_queues).join(',')}" unless fetch(:delayed_job_queues).nil?
  args << "--prefix=#{fetch(:delayed_job_prefix)}" unless fetch(:delayed_job_prefix).nil?
  args << fetch(:delayed_job_pools, {}).map {|k,v| "--pool=#{k}:#{v}"}.join(' ') unless fetch(:delayed_job_pools).nil?
  args.join(' ')
end

def delayed_job_bin
  "#{fetch(:delayed_job_bin_path)}/delayed_job"
end

def delayed_job_start_command
  "#{fetch(:rbenv_prefix)} bundle exec #{delayed_job_bin} #{delayed_job_args} -i \#{i} start"
end

def delayed_job_stop_command
  "#{fetch(:rbenv_prefix)} bundle exec #{delayed_job_bin} -i \#{i} stop"
end

# Watch the delayed_job processes using the build in template
namespace :eye do
  task :watch_process do

    watch_process(:delayed_job, {
      start_command: delayed_job_start_command,
      stop_command: delayed_job_stop_command
    })

  end
end

# Override start, restart and stop delayed_job tasks to so they call
# the eye equivalents
namespace :delayed_job do
  ['start','restart','stop'].each do |cmd|
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

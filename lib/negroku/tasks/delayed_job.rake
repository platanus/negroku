## delayed_job.rb
#
# Adds delayed jobs specific variables and tasks

namespace :load do
  task :defaults do
    set :delayed_job_workers, 1
    set :delayed_job_queues, nil
    set :delayed_job_pool, nil

    set :delayed_job_prefix, -> { "#{fetch(:application)}" }
  end
end

namespace :negroku do

  namespace :delayed_job do

    define_logs(:delayed_job, {
      out: 'delayed_job.log'
    })

  end

end


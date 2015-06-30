## whenever.rb
#
# Adds whenever/capistrano specific variables and tasks

namespace :load do
  task :defaults do

    # Whenever will update the crontab only if one of the
    # server roles matches the following list
    set :whenever_roles, [:app]

    set :whenever_log, -> { "#{shared_path}/log/whenever-out.log" }

    set :whenever_template, -> { "bash -lc ':job'" }

    # Set default jobs and log
    set :whenever_variables, -> {
      {
        job_template: fetch(:whenever_template),
        output: fetch(:whenever_log)
      }
      .map{|k,v| "#{k}=#{v}"}.join("&").prepend("\"") << "\""
    }

  end
end

namespace :negroku do

  namespace :whenever do

    define_logs(:whenever, {
      out: 'whenever-out.log'
    })

  end

end


## env.rake
#

namespace :env do
  desc 'Env variables changed'
  task :changed do
  end

  Rake::Task['env:changed'].enhance do
    # Change whether the config changed or not
    Rake::Task['eye:hard_restart'].invoke
  end
end

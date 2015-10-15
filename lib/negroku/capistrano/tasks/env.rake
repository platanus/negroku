## env.rake
#

namespace :env do
  desc 'Env variables changed'
  task :changed do
  end

  after 'env:changed', 'eye:hard_restart'
end

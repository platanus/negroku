## github.rb
#
# Adds capistrano/github specific variables and tasks

namespace :load do
  task :defaults do

    set :github_access_token, ENV['GITHUB_API_TOKEN']

  end
end

namespace :negroku do

  namespace :gihub do

    before 'deploy:starting', 'github:deployment:create'
    after  'deploy:starting', 'github:deployment:pending'
    after  'deploy:finished', 'github:deployment:success'
    after  'deploy:failed',   'github:deployment:failure'

  end

end


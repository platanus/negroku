## nginx.rb
#
# Adds capistrano3/nginx specific variables and tasks

namespace :load do
  task :defaults do

  end
end

# Adds some task on complement the capistrano3-nginx tasks
# This tasks are under the negroku namespace for easier identification
namespace :negroku do

    namespace :nginx do
        # Reload or restart unicorn after the application is published
        after 'deploy:publishing', 'restart' do
          invoke 'nginx:site:add'
          invoke 'nginx:site:enable'
          invoke 'nginx:reload'
        end
    end
end


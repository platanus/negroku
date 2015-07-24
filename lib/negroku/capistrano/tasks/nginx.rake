## nginx.rb
#
# Adds capistrano3/nginx specific variables and tasks

namespace :load do
  task :defaults do

    set :nginx_ssl_certificate_path,     -> { "#{shared_path}/ssl" }
    set :nginx_ssl_certificate_key,      -> { "#{fetch(:application)}.key" }
    set :nginx_ssl_certificate_key_path, -> { "#{shared_path}/ssl" }

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

        define_logs(:nginx, {
          error: 'nginx-error.log',
          access: 'nginx-access.log'
        })
    end
end

# Ensure the folders needed exist
task 'deploy:check:directories' do
  on release_roles fetch(:nginx_roles) do
    if fetch(:nginx_use_ssl)
      execute :mkdir, '-pv', "#{shared_path}/ssl"
    end
  end
end

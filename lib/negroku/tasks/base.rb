# Wrapper method for quickly loading, rendering ERB templates
# and uploading them to the server.
def template(from, to)
  erb = File.read(File.expand_path("../templates/#{from}", __FILE__))
  put ERB.new(erb).result(binding), to
end

# Wrapper method to set default values for recipes.
def set_default(name, *args, &block)
  set(name, *args, &block) unless exists?(name)
end

# Review and modify the tasks below on a per-app/language/framework basis.
namespace :deploy do
  after "deploy:update_code", "deploy:post"
  desc "Performs the post-deploy tasks."
  task :post do
    symlinks
    migrate
  end

  desc "Performs an Active Record migration."
  task :migrate do
    run "cd '#{release_path}' && RAILS_ENV=#{rails_env} bin/rake db:migrate"
  end

  desc "Sets up additional symlinks after deploy."
  task :symlinks do
    # Exmaple:
    # run "ln -nfs '#{shared_path}/yourfile' '#{release_path}/yourfile'"
  end

  after "deploy:setup", "deploy:setup_shared"
  desc "Sets up additional folders/files after deploy:setup."
  task :setup_shared do
    run "mkdir -p '#{shared_path}/config'"
  end

  desc "Restarts the app server."
  task :restart do
    # Example:
    # restart_torquebox_app
    # restart_upstart_app
  end
end

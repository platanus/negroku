# bower vars tasks

namespace :bower do
  before "deploy:assets:precompile", "bower:install"
  desc "Install static dependencies with bower"
  task :install, :roles => :web do
    run "cd #{release_path} && bower install"
  end
end

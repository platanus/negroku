# rbenv vars tasks

namespace :rbenv do
  namespace :vars do
    desc "Show current rbenv vars"
    task :show, :roles => :app do
      run "sh -c 'cd #{shared_path} && cat .rbenv-vars'"
    end

    desc "Add rbenv vars"
    task :add, :roles => :app do
      run "echo '#{key}=#{value}' >> #{shared_path}/.rbenv-vars"
    end

    after "deploy:finalize_update", "rbenv:vars:symlink"
    desc "Symlink rbenv-vars file into the current release"
    task :symlink, :roles => :app do
      run "ln -nfs '#{shared_path}/.rbenv-vars' '#{release_path}/.rbenv-vars'"
    end
  end
end

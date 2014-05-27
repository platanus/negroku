set_default :rbenv_roles, [:app]

# rbenv vars tasks

namespace :rbenv do
  namespace :vars do
    desc "Show current rbenv vars"
    task :show, :roles => lambda { rbenv_roles } do
      run "sh -c 'cd #{shared_path} && cat .rbenv-vars'"
    end

    desc "Add rbenv vars"
    task :add, :roles => lambda { rbenv_roles } do
      run "if awk < #{shared_path}/.rbenv-vars -F= '{print $1}' | grep --quiet #{key}; then sed -i 's/^#{key}=.*/#{key}=#{value}/g' #{shared_path}/.rbenv-vars; else echo '#{key}=#{value}' >> #{shared_path}/.rbenv-vars; fi"
    end

    after "deploy:finalize_update", "rbenv:vars:symlink"
    desc "Symlink rbenv-vars file into the current release"
    task :symlink, :roles => lambda { rbenv_roles } do
      run "ln -nfs '#{shared_path}/.rbenv-vars' '#{release_path}/.rbenv-vars'"
    end
  end
end

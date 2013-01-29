# RBEnv
#------------------------------------------------------------------------------
#
set_default :ruby_version, "1.9.3-p125"

namespace :rbenv do
  namespace :vars do
    desc "Show current rbenv vars"
    task :show, :roles => :app do
      run "sh -c 'cd #{shared_path} && cat .rbenv-vars'"  do |channel, stream, data|
        puts data
      end
    end

    desc "Add rbenv vars"
    task :add, :roles => :app do
      run "echo '#{key}=#{value}' >> #{shared_path}/.rbenv-vars"
    end
  end
end
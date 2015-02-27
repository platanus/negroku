## rbenv.rb
#
# Adds capistrano/rbenv specific variables and tasks

namespace :load do
  task :defaults do

    # Set the ruby version using the .ruby-version file
    # Looks for the file in the project root
    set :rbenv_ruby, File.read('.ruby-version').strip if File.exist?('.ruby-version')

    # Link .rbenv-vars file
    set :linked_files, fetch(:linked_files, []) << '.rbenv-vars'

    # Set the path to rbenv
    set :rbenv_path, "/home/deploy/.rbenv"
  end
end

namespace :env do
  desc 'Env variables changed'
  task :changed do
  end
end

namespace :rbenv do
  namespace :vars do
    desc "Show current environmental variables"
    task :show do
      on release_roles :app do
        within current_path do
          execute :rbenv, 'vars'
        end
      end
    end

    desc "Add environmental variables in the form VAR=value"
    task :add, [:variable] => 'deploy:check:linked_files' do |t, args|

      vars = [args.variable] + args.extras

      on release_roles :app do
        within shared_path do
          vars.compact.each do |var|
            key, value = var.split('=')
            cmd = build_add_var_cmd("#{shared_path}/.rbenv-vars", key, value)
            execute cmd
          end
        end
      end

    end

    desc "Remove environmental variable"
    task :remove, [:key] do |t, args|
      on release_roles :app do
        within shared_path do
          execute :sed, "-i", "/^#{args[:key]}=/d", ".rbenv-vars"
        end
      end
    end

    # Ensure the rbenv-vars file exist
    before 'deploy:check:linked_files', 'deploy:check:files' do
      on release_roles fetch(:rbenv_roles) do
        within shared_path do
          execute :touch, ".rbenv-vars"
        end
      end
    end

    after 'rbenv:vars:add', 'env:changed'
    after 'rbenv:vars:remove', 'env:changed'

  end
end

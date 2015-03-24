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

    desc "Sets environmental variables in the form VAR=value"
    task :set, [:variable] => 'deploy:check:directories' do |t, args|

      vars = [args.variable] + args.extras

      on release_roles :app do
        within shared_path do
          vars.compact.each do |var|
            key, value = var.split('=')
            cmd = build_set_var_cmd("#{shared_path}/.rbenv-vars", key, value)
            execute cmd
          end
        end

        if test "[ -d #{current_path} ]"
          invoke 'env:changed'
        end
      end

    end

    desc "Unset environmental variable"
    task :unset, [:key] do |t, args|
      on release_roles :app do
        within shared_path do
          execute :sed, "-i", "/^#{args[:key]}=/d", ".rbenv-vars"
        end

        if test "[ -d #{current_path} ]"
          invoke 'env:changed'
        end
      end
    end

    # Ensure the rbenv-vars file exist
    after 'deploy:check:directories', 'check:files' do
      on release_roles fetch(:rbenv_roles) do
        within shared_path do
          execute :touch, ".rbenv-vars"
        end
      end
    end

  end
end

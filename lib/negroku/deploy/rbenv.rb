## rbenv.rb
#
# Adds capistrano/rbenv specific variables and tasks

namespace :load do
  task :defaults do

    # Set the ruby version using the .ruby-version file
    # Looks for the file in the project root
    set :rbenv_ruby, File.read('.ruby-version').strip

    # Link .rbenv-vars file
    set :linked_files, fetch(:linked_files, []) << '.rbenv-vars'
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

    desc "Add environmental variable"
    task :add, [:key, :value] do |t, args|
      key = args[:key]
      value = args[:value]
      on release_roles :app do
        within shared_path do
          unless test "[ ! -f .rbenv-vars ]"
            execute :touch, ".rbenv-vars"
          end
          execute "if awk < #{shared_path}/.rbenv-vars -F= '{print $1}' | grep --quiet ^#{key}$; then sed -i 's/^#{key}=.*/#{key}=#{value}/g' #{shared_path}/.rbenv-vars; else echo '#{key}=#{value}' >> #{shared_path}/.rbenv-vars; fi"
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

  end
end

## thinkinx_sphinx.rb
#
# Adds thinking sphinx specific variables and tasks

namespace :load do
  task :defaults do

    set :thinking_sphinx_roles, :app

    # Local path to look for custom config template
    set :thinking_sphinx_template, -> { "config/deploy/#{fetch(:stage)}/thinking_sphinx.yml.erb" }

    set :thinking_sphinx_env, -> { fetch(:rails_env) || fetch(:stage) }

    # Link thinking_sphinx.yml file
    set :linked_files, fetch(:linked_files, []) << 'config/thinking_sphinx.yml'

    # Thinking Sphinx config defaults
    set :thinking_sphinx_pid_file,            -> { "#{shared_path}/tmp/pids/searchd.pid" }
    set :thinking_sphinx_indices_location,    -> { "#{shared_path}/db/sphinx" }
    set :thinking_sphinx_configuration_file,  -> { "#{shared_path}/config/sphinx.conf" }
    set :thinking_sphinx_binlog_path,         -> { "#{shared_path}/sphinx_binlog" }
    set :thinking_sphinx_log,                 -> { "#{shared_path}/log/searchd.log" }
    set :thinking_sphinx_query_log,           -> { "#{shared_path}/log/searchd.query.log" }
  end
end

namespace :negroku do

  namespace :thinking_sphinx do

    desc "Upload thinking sphinx configuration file"
    task :setup do
      on release_roles fetch(:thinking_sphinx_roles) do
        within "#{shared_path}/config" do
          template_path = fetch(:thinking_sphinx_template)

          # user a build in template if the template doesn't exists in the project
          unless File.exists?(template_path)
            template_path = "capistrano/templates/thinking_sphinx.yml.erb"
          end

          config = build_template(template_path, nil, binding)
          upload! config, '/tmp/thinking_sphinx.yml'

          execute :mv, '/tmp/thinking_sphinx.yml', 'thinking_sphinx.yml'
        end
      end
    end

    # Backup the config
    task :backup_config do
      on release_roles fetch(:thinking_sphinx_roles) do
        within "#{shared_path}/config" do
          if test("[ -f #{fetch(:thinking_sphinx_configuration_file)} ]")
            execute :cp, fetch(:thinking_sphinx_configuration_file), '/tmp/sphinx.conf.bak'
          else
            set :thinking_sphinx_config_changed, true
          end
        end
      end
    end

    # Check whether the conf changed
    task :check_config do
      on release_roles fetch(:thinking_sphinx_roles) do
        within "#{shared_path}/config" do
          if fetch(:thinking_sphinx_config_changed, nil).nil?
            config_diff = capture "diff -q /tmp/sphinx.conf.bak #{fetch(:thinking_sphinx_configuration_file)}", raise_on_non_zero_exit: false
            set :thinking_sphinx_config_changed, !config_diff.empty?
          end
        end
      end
    end

    # Backup the config on every configure
    Rake::Task['thinking_sphinx:configure'].enhance ['negroku:thinking_sphinx:backup_config'] do
      # Change whether the config changed or not
      Rake::Task['negroku:thinking_sphinx:check_config'].invoke
    end

    task :rebuild do
      on release_roles fetch(:thinking_sphinx_roles) do
        within current_path do
          with rails_env: fetch(:rails_env), index_only: true do
            invoke 'thinking_sphinx:stop'
            sleep 2
            execute :rake, 'ts:clear'
            execute :rake, 'ts:index'
            invoke 'thinking_sphinx:start'
          end
        end
      end
    end

    # Configure and regenerate after the application is published
    after 'deploy:published', 'restart' do
      invoke 'negroku:thinking_sphinx:setup'
      invoke 'thinking_sphinx:configure'

      # Rebuild the index
      invoke 'negroku:thinking_sphinx:rebuild' if fetch(:thinking_sphinx_config_changed)
    end

    define_logs(:sphinx, {
      out: 'searchd.log',
      query: 'searchd.query.log'
    })

  end

end

# Ensure the folders needed exist
task 'deploy:check:directories' do
  on release_roles fetch(:thinking_sphinx_roles) do
    execute :mkdir, '-pv', "#{shared_path}/db"
    execute :mkdir, '-pv', "#{shared_path}/tmp/pids"
    execute :mkdir, '-pv', "#{shared_path}/sphinx_binlog"
    execute :touch, "#{shared_path}/config/thinking_sphinx.yml"
  end
end

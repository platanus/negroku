## eye.rb
#
# Adds eye variables and tasks
namespace :load do
  task :defaults do
    ###################################
    ## eye template variables

    # Local path to look for custom config template
    set :eye_template, -> { "config/deploy/#{fetch(:stage)}/eye.rb.erb" }

  end
end


namespace :eye do

  task :start, [:process] do

  end

  task :restart, [:process] do

  end

  task :stop, [:process] do

  end

  task :status do

  end
  desc "test"
  task :test do
    # binding.pry
        load_processes
    # on release_roles fetch(:eye_roles) do
    #   within "#{shared_path}/config" do
    #   end
    # end
  end
end


# Adds some task on complement the capistrano3-unicorn tasks
# This tasks are under the negroku namespace for easier identification
namespace :negroku do

  namespace :eye do

    desc "Upload eye configuration file"
    task :setup do
      on release_roles fetch(:eye_roles) do
        within "#{shared_path}/config" do
          processes = fetch(:eye_processes, {})

          template_path = fetch(:eye_template)

          # user a build in template if the template doesn't exists in the project
          unless File.exists?(template_path)
            template_path = "tasks/eye/eye.rb.erb"
          end

          config = build_template(template_path, nil, binding)
          upload! config, '/tmp/eye.rb'

          execute :mv, '/tmp/eye.rb', 'eye.rb'
        end
      end
    end

    define_logs(:eye, {
      app: 'production.log'
    })

  end

end

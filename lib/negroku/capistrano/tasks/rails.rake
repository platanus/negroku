## rails.rb
#
# Adds rails variables and tasks
# Rails main tasks are loaded from the gem capistrano-rails

namespace :load do
  task :defaults do

  end
end

namespace :negroku do

  namespace :rails do

    define_logs(:rails, {
      app: 'production.log'
    })

  end

end

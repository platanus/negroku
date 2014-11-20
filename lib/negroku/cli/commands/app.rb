module Negroku::CLI

  desc 'Create and manage your app'
  command :app do |app|

    app.desc 'Bootstrap your application with capistrano and negroku'
    app.command :create do |create|
      create.action do |global_options,options,args|

        Negroku::Bootstrap.install

      end
    end

    app.desc 'Bootstrap your application with capistrano and negroku'
    app.command :stage do |stage|

      stage.desc 'Bootstrap your application with capistrano and negroku'
      stage.command :add do |add|
        add.action do |global_options,options,args|

          Negroku::Bootstrap.add_stage

        end
      end

      stage.desc 'Bootstrap your application with capistrano and negroku'
      stage.command :remove do |remove|
        remove.action do |global_options,options,args|

          Negroku::Bootstrap.remove_stage args.first

        end
      end

    end

  end
end

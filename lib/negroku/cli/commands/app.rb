module Negroku::CLI

  desc 'Create and manage your app'
  command :app do |app|

    app.desc 'Bootstrap your application with capistrano and negroku'
    app.command :create do |create|
      create.action do |global_options,options,args|

        Negroku::App.install

      end
    end

    app.desc 'Update your negroku capfile'
    app.command :update do |create|
      create.action do |global_options,options,args|

        Negroku::App.update

      end
    end

  end
end

module Negroku::CLI

  desc 'Create and manage your app'
  command :app do |app|

    app.desc 'Bootstrap your application with capistrano and negroku'
    app.command :create do |create|
      create.action do |global_options,options,args|

        Negroku::Bootstrap.install

      end
    end

  end
end

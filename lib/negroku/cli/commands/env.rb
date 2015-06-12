module Negroku::CLI

  desc 'Manage your apps env variables'
  command :env do |app|

    app.desc 'Sets multiple variables from rbenv-vars to a server'
    app.command :bulk do |bulk|
      bulk.action do |global_options,options,args|
        Negroku::Modes::Env.bulk
      end
    end

  end
end

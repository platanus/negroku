module Negroku::CLI

  # This is the default negroku command
  # Here we'll manage the main interative cli ui
  command :negroku do |c|

    c.default_command :ask
    c.command :ask do |s|
      s.action do |global_options,options,args|

      end
    end

  end
end

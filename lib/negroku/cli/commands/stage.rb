module Negroku::CLI

  desc 'Create and manage stages'
  command :stage do |stage|

    stage.desc 'Adds a new stage'
    stage.command :add do |add|
      add.action do |global_options,options,args|

        Negroku::Modes::Stage.add

      end
    end
  end

end

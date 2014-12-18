require 'pathname'

module AppDirectory
  extend self

  def config
    @config ||= Pathname.new('config')
  end

  def root
    @root ||= Pathname.new('')
  end

  def deploy
    config.join('deploy')
  end

  def tasks
    @tasks ||= Pathname.new('lib/capistrano/tasks')
  end

end

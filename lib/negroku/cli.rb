require 'thor'
require 'negroku/helpers'

class App < Thor

  desc "create", "Create application. Intialize the capfile, also create the deploy.rb file in the config folder"
  method_option :local_recipes, :type => :boolean, :aliases => "-l"
  def create
    data = {}
    say "We're about to create your application deploy setup"
    data[:application_name] = ask "Give your application a name:"
    data[:repo] = aks("Are you going to use github:", :limited_to => ["github", "bitbucket"])
    data[:target_server] = aks("Where are you going to deploy:", :limited_to => ["szot", "kross"])
    init(".", data)
  end

  desc "deploy", "Deploy the application"
  def deploy
    put "I will deploy"
  end
end

class Repo < Thor

  desc "add", "add new default repositories"
  def add(url=nil)
    if url.nil?
      url = ask("Type the url and username e.g.  git@github.com:username")
    end
    saveConfig("add", "repo", url)
  end

  desc "remove", "remove some repo"
  def remove
    puts "I will remove a repo"
  end
end

class Target < Thor
  desc "add", "add new default target server"
  def add(host=nil)
    if host.nil?
      host = ask("Type the host or ip for the target machine")
    end
    saveConfig("add", "target", host)
  end

  desc "remove", "remove some target"
  def remove
    puts "I will remove a target"
  end
end

class Konfig < Thor
  namespace "config"

  desc "show", "Show the current configuration file"
  def show
    showConfig
  end
end

module Negroku
  class CLI < Thor
    register(App, 'app', 'app [COMMAND]', 'Application')
    register(Repo, 'repo', 'repo [COMMAND]', 'Repositories')
    register(Target, 'target', 'target [COMMAND]', 'Target servers')
    register(Konfig, 'config', 'config [COMMAND]', 'Configuration')
  end
end
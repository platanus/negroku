require 'thor'
require 'rainbow'
require 'highline/import'

trap('INT') { exit }

class App < Thor

  say "\n\n#############################################".bright()
  say "##                NEGROKU                  ##".bright()
  say "#############################################\n".bright()

  desc "create", "Create application. Intialize the capfile, also create the deploy.rb file in the config folder"
  method_option :local_recipes, :type => :boolean, :aliases => "-l"
  method_option :path, :type => :string, :aliases => "-p"
  def create(name=nil)
    # Get configuration
    config = getConfig

    # Test for config
    if config.empty?
      say "Warning".foreground(:red)
      say "It's recommended that you add some default settings to negroku before you create your app deployment\n\n"
      say "For example you can add your most common git urls using:\n"
      say "negroku repo add git@github.com:yourusername.git\n".foreground(:yellow)
      say "Also you can add your deployment servers urls using:\n"
      say "negroku target add my.deployment.com".foreground(:yellow)
      say "negroku target add 104.284.3.1\n".foreground(:yellow)
      unless yes? "Do you want to continue without adding default settings? [y/N]"
        exit
      end
    end

    say "We're about to create your application deploy setup\n".foreground(:green)

    # Hash to hold the app info
    data = {}

    # Get the name
    if name.nil?
      data[:application_name] = ask "Give your application a name:".bright()
    else
      data[:application_name] = name
    end

    # The application code repository
    if config[:repo]
      choose do |menu|

        say "\nREPOSITORIES".foreground(:yellow)
        menu.prompt = "Please choose your repository?".bright()

        config[:repo].each do |val|
          repo_url = "#{val}/#{data[:application_name]}.git"
          unless repo_url == local_repo
            menu.choice(repo_url) do |command|
              say("Using #{command}/#{data[:application_name]}.git")
              data[:repo] = command;
            end
          end
        end

        menu.choice(:other) {
          data[:repo] = ask "Type the url and username e.g. git@github.com:username".bright()
        }
      end
    else
      data[:repo] = ask "Type the url and username e.g. git@github.com:username".bright()
    end

    # The application target deploy server
    if config[:repo]
      choose do |menu|

        say "\nTARGET SERVERS".foreground(:yellow)
        menu.prompt = "Please choose your deployment server?".bright()

        config[:target].each do |val|
          menu.choice(val) do |command|
            say("Using #{command}")
            data[:target_server] = command;
          end
        end

        menu.choice(:other) {
          data[:target_server] = ask "Type the hostname or ip of the server to deploy to".bright()
        }
      end
    else
      data[:target_server] = ask "Type the hostname or ip of the server to deploy to".bright()
    end

    init(".", data)

    say "\n\nWhat to do next?\n".bright()
    say "you can try with     cap -T    to see the available tasks"
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
    saveConfig(:add, :repo, url)
  end

  desc "remove", "remove some repo"
  def remove
    puts "I will remove a repo"
  end

  desc "list", "show the repost"
  def list
    puts "I will list the target servers"
  end
end

class Target < Thor
  desc "add", "add new default target server"
  def add(host=nil)
    if host.nil?
      host = ask("Type the host or ip for the target machine")
    end
    saveConfig(:add, :target, host)
  end

  desc "remove", "remove some target"
  def remove
    puts "I will remove a target"
  end

  desc "list", "show the targets"
  def list
    puts "I will list the target servers"
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
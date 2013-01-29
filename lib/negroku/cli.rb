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
      say "[WARNING]".foreground(:red)
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
    choose do |menu|

      say "\nREPOSITORIES"
      say "============"
      menu.prompt = "Please choose your repository?".bright()
      menu.select_by = :index

      # find local remote from git repo
      if File.directory?(".git")
        say "[INFO] The first repo was taken from the local git checkout remotes".color(:yellow)
        local_repo = %x(git remote -v | grep origin | grep push | awk '{print $2}').gsub(/\n/,"")
        menu.choice("#{local_repo}") do |command|
          say("Using #{command}")
          data[:repo] = command;
        end
      end

      # adds the repos in the config file if there is one
      if config[:repo]
        config[:repo].each do |val|
          repo_url = "#{val}/#{data[:application_name]}.git"
          # skip if the repo url is the same as the local one
          unless repo_url == local_repo
            menu.choice(repo_url) do |command|
              say("Using #{command}/#{data[:application_name]}.git")
              data[:repo] = command;
            end
          end
        end
      else
        say "[INFO] There are no repos in the default settings".color(:yellow)
      end

      # add other repo choice
      menu.choice(:other) {
        data[:repo] = ask "Type the url and username e.g. git@github.com:username: ".bright()
      }
    end

    # The application target deploy server
    choose do |menu|

      say "\nTARGET SERVERS"
      say "=============="
      menu.prompt = "Please choose your deployment server?".bright()
      menu.select_by = :index

      # Adds the targets in the config file if there is one
      if config[:repo]
        config[:target].each do |val|
          menu.choice(val) do |command|
            say("Using #{command}")
            data[:target_server] = command;
          end
        end
      else
        say "[INFO] There are no target urls in the default settings".color(:yellow)
      end

      menu.choice(:other) {
        data[:target_server] = ask "Type the hostname or ip of the server to deploy to:".bright()
      }
    end

    # Add custom domain
    say "\nCUSTOM DOMAIN"
    say "============="
    if yes? "Do you want to use  #{data[:target_server].gsub(/^([a-z\d]*)/, data[:application_name])}? [Y/n]"
      data[:domains] = data[:target_server].gsub(/^([a-z\d]*)/, data[:application_name])
    else
      data[:domains] = ask "Please enter the domains separated by spaces"
    end


    init(".", data)

    say "\n\nWhat to do next?\n".bright()
    say "You can try with     cap -T    to see the available tasks"
    say "Also you can check the config/deploy.rb file, you may want to change some things there"
    say "\n HAPPY DEPLOY".foreground(:green)
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
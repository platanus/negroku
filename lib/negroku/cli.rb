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
      say "It's recommended that you add some custom settings to negroku before you create your app deployment\n\n"
      say "You can add your deployment servers urls using:\n"
      say "negroku target add my.deployment.com".foreground(:yellow)
      say "negroku target add 104.284.3.1\n".foreground(:yellow)
      unless agree "You have not added custom settings! Do you want to continue? [y/n]", true
        say "Goodbye"
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
        local_repos = %x(git remote -v | awk '{print $2}' | uniq).split("\n")
        local_repos.each do |url|
          menu.choice(url) do |command|
            say("Using #{command}")
            data[:repo] = command;
          end
        end
      end

      # add other repo choice
      menu.choice(:other) {
        data[:repo] = ask "Type the url and username e.g. git@github.com:username/app-name.git: ".bright()
      }
    end

    # The application target deploy server
    choose do |menu|

      say "\nTARGET SERVERS"
      say "=============="
      menu.prompt = "Please choose your deployment server?".bright()
      menu.select_by = :index

      # Adds the targets in the config file if there is one
      if config[:target]
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
    if agree "Do you want to use  #{data[:target_server].gsub(/^([a-z\d]*)/, data[:application_name])}? [y/n]", true
      data[:domains] = data[:target_server].gsub(/^([a-z\d]*)/, data[:application_name])
    else
      data[:domains] = ask "Please enter the domains separated by spaces"
    end


    init(".", data)

    say "\n\nWhat to do next?\n".bright()
    say "Setup your app running " + "cap deploy:setup".color(:yellow)
    say "You can try with " + "cap -T".color(:yellow) +" to see the available tasks"
    say "Also you can check the " + "config/deploy.rb".color(:yellow) + " file, you may want to change some things there"
    say "NOTE: If this is the first time the app is deployed, use the task " + "cap deploy:cold".color(:yellow)
    say "\n HAPPY DEPLOY".foreground(:green)
  end
end

class Target < Thor
  desc "add", "add new default target server"
  def add(host=nil)
    if host.nil?
      host = ask("Type the host or ip for the target machine")
    end
    saveConfig(:add, :target, host)
    say "[Negroku] Added #{host}"
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

class RemoteEnv < Thor
  namespace "env"

  desc "show", "Show the current remote variables"
  def show
    `cap rbenv:vars:show`
  end

  desc "add", "Adds env variables to the remote server"
  method_option :local, :type => :boolean, :aliases => "-l"
  def add(key=nil, value=nil)

    # Check if the paramenter were sent in the call
    # Ask for the value if only the key was sent
    if !key.nil? && value.nil?
      value = ask("Please enter the value for #{key}:")
    # If nothing was sent
    elsif key.nil? && value.nil?
      # Check if the .rbenv-vars file exists and offer get the info from there
      if File.exist?(".rbenv-vars") && (agree "Do you want to add variables from your local .rbenv-vars file [y/n]", true)
        choose do |menu|
          menu.prompt = "Please choose variable you want to add?".bright()
          menu.select_by = :index

          File.readlines(".rbenv-vars").each do |line|
            menu.choice(line.gsub("\n","")) do |command|
              key = command.split("=")[0]
              value = command.split("=")[1]
            end
          end
        end
      else
        key = ask("Please enter the variable key:")
        value = ask("Please enter the value for #{key}:")
      end
    end

    `cap rbenv:vars:add -s key=#{key} -s value=#{value}`
  end
end

module Negroku
  class CLI < Thor
    register(App, 'app', 'app [COMMAND]', 'Application')
    register(Target, 'target', 'target [COMMAND]', 'Target servers')
    register(Konfig, 'config', 'config [COMMAND]', 'Configuration')
    register(RemoteEnv, 'env', 'env [COMMAND]', 'Remote environmental variables')
  end
end

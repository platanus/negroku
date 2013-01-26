require 'yaml'

# the yaml file where we'll write the settings
CONFIG_FILE = File.join(ENV['HOME'], ".negroku", "config.yaml")

def init(target=".", data)
  puts target
  # Create the cap file if not found
  if Dir.entries(target).include?("Capfile")
    puts "[Negroku] => Found Capfile!"
  else
    puts "[Negroku] => Capifying!"
    `capify #{File.expand_path(target)}`
  end
  path    = File.expand_path(target)
  capfile = File.expand_path(File.join(target, "Capfile"))

  # Find or create config folder
  unless File.directory?(File.join(path, "config"))
    puts "[Negroku] => Could not find the \"config\" folder. Creating it now!"
    %x(mkdir #{File.join(path, 'config')})
  end

  # replace and rename older deploy.rb
  if File.exist?(File.join(path, "config", "deploy.rb"))
    puts "[Negroku] => Backing up deploy.rb"
    old_versions = Dir.entries(File.join(path, 'config')).map {|entree| entree if entree =~ /deploy\.old\.(\d+)\.rb$/}.compact!
    if old_versions.empty?
      %x(mv #{File.join(path, 'config', 'deploy.rb')} #{File.join(path, 'config', 'deploy.old.1.rb')})
    else
      version = old_versions.last.match('^deploy\.old\.(\d+)\.rb$')[1].to_i + 1
      %x(mv #{File.join(path, 'config', 'deploy.rb')} #{File.join(path, 'config', "deploy.old.#{version}.rb")})
    end
  else
    puts "[Negroku] => Could not find deploy.rb. Creating a new one!"
  end

  # Create the new deploy
  puts "[Negroku] => Writing new deploy.rb."
  erb = File.read(File.join(File.dirname(__FILE__), '../lib', 'negroku', 'deploy.rb.erb'))
  File.open(File.join(path, 'config', 'deploy.rb'), 'w') do |f|
    f.write ERB.new(erb).result(binding)
  end

  # checks for both require "negroku" and require "negroku/initializer"
  unless File.open(File.join('Capfile'), 'r').read.include?('require "negroku"')
    puts "[Negroku] => Adding Negroku Loader inside #{path}/Capfile."
    File.open(File.join(path, 'Capfile'), "a") do |cfile|
  cfile << <<-capfile
  \n
  require "negroku"
  load negroku
  capfile
    end
  end
end

def saveConfig(action, type, data)
  # create the ~/.negroku folder
  unless File.directory?(File.join(ENV['HOME'], ".negroku"))
    puts "[Negroku] => Creating config file in #{ENV['HOME']}/.negroku"
    %x(mkdir #{File.join(ENV['HOME'], ".negroku")})
  end

  # create an empty config.yaml file
  unless File.exist?(CONFIG_FILE)
    %x(touch #{CONFIG_FILE})
  end

  # Load the yaml file
  config = YAML.load_file(CONFIG_FILE) || {}

  # If I need to add some multiple values
  if action == "add"
    newData = config[type] || []
    newData.push(data)
    newData.uniq!
    config = config.merge({ type => newData })
  elsif action == "remove"
    #..
  elsif action == "replace"
    #..
  end

  File.open(CONFIG_FILE, 'w') do |f|
    f.write config.to_yaml
  end
end

def showConfig()
  # Load the yaml file
  config = YAML.load_file(CONFIG_FILE) || {}
  puts config
end
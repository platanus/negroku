require 'yaml'

# the yaml file where we'll write the settings
CONFIG_FILE = File.join(ENV['HOME'], ".negroku", "config.yaml")

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
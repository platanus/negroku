require 'yaml'

def saveConfig(action, type, data)
  # Load the yaml file
  config_file = File.join(ENV['HOME'], ".negroku")
  config = getConfig

  # If I need to add some multiple values
  if action === :add
    newData = config[type] || []
    newData.push(data)
    newData.uniq!
    config = config.merge({ type => newData })
  elsif action === :remove
    #..
  elsif action === :replace
    #..
  end

  File.open(config_file, 'w') do |f|
    f.write config.to_yaml
  end
end

def getConfig
  # load config from file
  config_file = File.join(ENV['HOME'], ".negroku")

  # create an empty .negroku file
  unless File.exist?(config_file)
    %x(touch #{config_file})
  end

  # base config
  YAML.load_file(config_file) || {}
end
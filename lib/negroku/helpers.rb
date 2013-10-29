def init(target=".", data)

  # Main locations
  target_path    = File.expand_path(target)
  config_path = File.join(target_path, "config")
  deploy_path = File.join(target_path, "config", "deploy")
  capfile = File.join(target_path, "Capfile")
  deployfile = File.join(config_path, "deploy.rb")
  stagingfile = File.join(deploy_path, "staging.rb")
  productionfile = File.join(deploy_path, "production.rb")

  # Create the cap file if not found
  if Dir.entries(target_path).include?("Capfile")
    puts "[Negroku] => Found Capfile!"
  else
    puts "[Negroku] => Capifying!"
    `capify #{target_path}`
  end

  # Find or create config folder
  unless File.directory?(config_path)
    puts "[Negroku] => Could not find the \"config\" folder. Creating it now!"
    %x(mkdir #{config_path})
  end

  # Find or create deploy folder
  unless File.directory?(deploy_path)
    puts "[Negroku] => Could not find the \"deploy\" folder. Creating it now!"
    %x(mkdir #{deploy_path})
  end

  # replace and rename older deploy.rb
  if File.exist?(deployfile)
    puts "[Negroku] => Backing up deploy.rb"
    old_versions = Dir.entries(config_path).map {|entree| entree if entree =~ /deploy\.old\.(\d+)\.rb$/}.compact!
    if old_versions.empty?
      %x(mv #{deployfile} #{File.join(config_path, 'deploy.old.1.rb')})
    else
      version = old_versions.last.match('^deploy\.old\.(\d+)\.rb$')[1].to_i + 1
      %x(mv #{deployfile} #{File.join(config_path, "deploy.old.#{version}.rb")})
    end
  end

  # Create the new deploy
  puts "[Negroku] => Writing new deploy.rb."
  erb = getTemplate 'deploy.rb.erb'
  File.open(deployfile, 'w') do |f|
    f.write ERB.new(erb).result(binding)
  end

  # Create the new configuration stages
  puts "[Negroku] => Writing new deploy/staging.rb"
  erb = getTemplate 'staging.rb.erb'
  File.open(stagingfile, 'w') do |f|
    f.write ERB.new(erb).result(binding)
  end
  puts "[Negroku] => Writing new deploy/production.rb"
  erb = getTemplate 'production.rb.erb'
  File.open(productionfile, 'w') do |f|
    f.write ERB.new(erb).result(binding)
  end

  # Prepares the Capfile for negroku
  cfile = Capfile.new(capfile)
  cfile.assets()
  puts "[Negroku] => Enabling assets tasks."
  cfile.negroku()
  puts "[Negroku] => Adding Negroku Loader inside #{capfile}."

end

def showConfig()
  # Load the yaml file
  config = getConfig
  puts config
end

def getTemplate(template)
  File.read(File.join(File.dirname(__FILE__), 'templates', template))
end

##
# Helper Method that assists in loading in tasks from the tasks folder
def load_tasks(tasks)
  load File.join(File.dirname(__FILE__), 'tasks', "#{tasks}.rb")
end

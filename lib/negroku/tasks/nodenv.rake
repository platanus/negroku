## nodenv.rb
#
# Adds capistrano/nodenv specific variables and tasks

namespace :load do
  task :defaults do

    # Set the node version using the .node-version file
    # Looks for the file in the project root
    set :nodenv_node, File.read('.node-version').strip if File.exist?('.node-version')

    # Set the path to rbenv
    set :nodenv_path, "/usr/local/nodenv"

  end
end

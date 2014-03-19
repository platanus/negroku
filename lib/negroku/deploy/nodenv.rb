## nodenv.rb
#
# Adds capistrano/nodenv specific variables and tasks

# Set the node version using the .node-version file
# Looks for the file in the project root
set :nodenv_node, File.read('.node-version').strip

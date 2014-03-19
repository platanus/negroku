## rbenv.rb
#
# Adds capistrano/rbenv specific variables and tasks

# Set the ruby version using the .ruby-version file
# Looks for the file in the project root
set :rbenv_ruby, File.read('.ruby-version').strip

## bower.rb
#
# Adds capistrano/bower specific variables and tasks

namespace :load do
  task :defaults do

    # Add bower to :nodenv_map_bins
    fetch(:nodenv_map_bins) << 'bower'

  end
end

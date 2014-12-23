require 'negroku/helpers/logs'
require 'negroku/helpers/env'

# Find out if a specific library file was already required
def was_required?(file)
  rex = Regexp.new("/#{Regexp.quote(file)}\.(so|o|sl|rb)?")
  $LOADED_FEATURES.find { |f| f =~ rex }
end

def load_task(name)
  load File.join(File.dirname(__FILE__), 'tasks', "#{name}.rake")
end

require 'negroku/helpers/templates'
require 'negroku/helpers/watch'
require 'negroku/helpers/logs'
require 'negroku/helpers/env'

# Find out if a specific library file was already required
def required?(file)
  rex = Regexp.new("/#{Regexp.quote(file)}\.(so|o|sl|rb)?")
  $LOADED_FEATURES.find { |f| f =~ rex }
end

def any_required?(arr)
  arr.each do |file|
    return true if(required?(file))
  end
end

def load_task(name)
  load File.join(File.dirname(__FILE__), 'tasks', "#{name}.rake")
end

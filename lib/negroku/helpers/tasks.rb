# Find out if a specific library file was already required
def required?(file)
  rex = Regexp.new("/#{Regexp.quote(file)}\.(so|o|sl|rb)?")
  $LOADED_FEATURES.find { |f| f =~ rex }
end

def any_required?(arr)
  arr.any? { |file| required?(file) }
end

def all_required?(arr)
  arr.all? { |file| required?(file) }
end

def load_task(name, dependencies = [])
  if all_required? dependencies
    load File.join(File.dirname(__FILE__), 'tasks', "#{name}.rake")
  else
    fail "To load #{name} you need to include #{dependencies.join ", "}"
  end
end

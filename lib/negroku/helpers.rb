# Find out if a specific library file was already required
def was_required?(file)
  rex = Regexp.new("/#{Regexp.quote(file)}\.(so|o|sl|rb)?")
  $LOADED_FEATURES.find { |f| f =~ rex }
end

def load_deploy(name)
  load File.join(File.dirname(__FILE__), 'deploy', "#{name}.rb")
end

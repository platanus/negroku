require "negroku/version"

##
# Returns a path that can be loaded by the "load" method inside the Capfile
def negroku
  File.join(File.dirname(__FILE__), 'negroku', 'deploy.rb')
end

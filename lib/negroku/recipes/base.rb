# Wrapper method for quickly loading, rendering ERB templates
# and uploading them to the server.
def template(from, to)
  erb = File.read(File.expand_path("../templates/#{from}", __FILE__))
  put ERB.new(erb).result(binding), to
end

# Wrapper method to set default values for recipes.
def set_default(name, *args, &block)
  set(name, *args, &block) unless exists?(name)
end

=begin
# List of ruby dependencies that should be installed.
set_default :ruby_dependencies, <<-EOS
  build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev \
  libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion
EOS

# List of jruby dependencies that should be installed.
set_default :jruby_dependencies, <<-EOS
  curl g++ openjdk-6-jre-headless
EOS

# List of common utils that should be installed.
set_default :general_packages, <<-EOS
  vim tree imagemagick curl git-core htop ufw
EOS

# Will install essential / common packages.
namespace :deploy do
  desc <<-EOS
    * Updates package list
    * Enable PPA (Custom Repositories)
    * Installs common packages (including: vim, imagemagick, git, curl, ufw)
    * Installs Ruby/JRuby dependencies
  EOS
  task :install do
    run "#{sudo} apt-get -y update"
    run "#{sudo} apt-get -y install python-software-properties"
    run "#{sudo} apt-add-repository ppa:blueyed/ppa"
    run "#{sudo} apt-get -y update"
    run "#{sudo} apt-get -y install #{general_packages} #{ruby_dependencies} #{jruby_dependencies}"
  end
end
=end

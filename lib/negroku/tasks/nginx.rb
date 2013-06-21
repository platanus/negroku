# Define the domains in an Array, these will be embedded in the uploaded nginx configuration file.
# Define either the app_server_port or app_server_socket when enabling app_server, else leave it blank.
# Places the SSL certs in /home/<user>/ssl/<application>.key and /home/<user>/ssl/<application>.crt when
# setting use_ssl to true.
# Define the `static_dir`, in Rails this would be `public`.
# Feel free to further modify the template to your needs as it doesn't cover every use-case of course,
# but tries to get all the common requirements out of the way to lessen research time (if any).

set_default :domains, ["your.domain.com"]
set_default :static_dir, "public"

set_default :app_server, true
#set_default :app_server_port, 8080
set_default :app_server_socket, "/home/#{fetch(:user)}/tmp/negroku.#{fetch(:application)}.sock"

# set_default :use_ssl, true
# set_default :ssl_key, "/path/to/local/ssh.key"
# set_default :ssl_crt, "/path/to/local/ssh.crt"

namespace :nginx do
  # after "deploy:install", "nginx:install"
  # desc "Install latest stable release of nginx."
  # task :install, roles: :web do
  #   run "#{sudo} add-apt-repository ppa:nginx/stable"
  #   run "#{sudo} apt-get -y update"
  #   run "#{sudo} apt-get -y install nginx"
  # end

  after "deploy:setup", "nginx:upload_ssl_certificates"
  desc "Upload SSL certificates for this application."
  task :upload_ssl_certificates, roles: :web do
    if fetch(:use_ssl, nil)
      run "mkdir -p /home/#{fetch(:user)}/ssl"
      upload ssl_key, "/home/#{fetch(:user)}/ssl/#{fetch(:application)}.key"
      upload ssl_crt, "/home/#{fetch(:user)}/ssl/#{fetch(:application)}.crt"
    end
  end

  after "deploy:setup", "nginx:setup"
  desc "Setup nginx configuration for this application."
  task :setup, roles: :web do
    config_file = "config/deploy/nginx.conf.erb"
    if File.exists?(config_file)
        config = ERB.new(File.read(config_file)).result(binding)
        put config, "/tmp/nginx.conf"
    else
      template "nginx.erb", "/tmp/nginx.conf"
    end
    run "#{sudo} mv /tmp/nginx.conf /etc/nginx/sites-available/#{fetch(:application)}"
    run "#{sudo} ln -nfs /etc/nginx/sites-available/#{fetch(:application)} /etc/nginx/sites-enabled/#{fetch(:application)}"
    run "mkdir -p /home/#{fetch(:user)}/log"
    reload
  end

  %w[start stop restart reload].each do |command|
    desc "#{command} Nginx."
    task command, roles: :web do
      run "#{sudo} service nginx #{command}"
    end
  end
end

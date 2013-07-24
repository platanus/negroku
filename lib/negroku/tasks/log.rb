namespace :log do
  desc "Stream (tail) the application's log."
  task :app do
    trap("INT") { puts 'Exit'; exit 0; }
    stream "tail -f '#{shared_path}/log/#{fetch(:rails_env)}.log'"
  end

  desc "Stream (tail) the nginx access log."
  task :nginx_access do
    trap("INT") { puts 'Exit'; exit 0; }
    stream "tail -f '/home/#{fetch(:user)}/log/#{fetch(:application)}-nginx-access.log'"
  end

  desc "Stream (tail) the nginx error log."
  task :nginx_error do
    trap("INT") { puts 'Exit'; exit 0; }
    stream "tail -f '/home/#{fetch(:user)}/log/#{fetch(:application)}-nginx-error.log'"
  end

  desc "Stream (tail) the unicorn error log."
  task :unicorn_error do
    trap("INT") { puts 'Exit'; exit 0; }
    stream "tail -f '#{fetch(:current_path)}/log/unicorn-error.log'"
  end
end

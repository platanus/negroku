## log.rb
#
# Dynamically adds log task based on log definitions
namespace :log do

  fetch(:negroku_logs, {}).each do |namespace, log|

    namespace namespace do

      log.each do |name, path|

        desc "Show #{namespace} #{name} log tail"
        task name, :lines do |t, args|
          on release_roles [:app, :web] do
            within current_path do
              old_state = `stty -g`
              system "stty -echoctl"

              args.with_defaults(:lines => 10)
              trap("INT") { puts 'Bye!'; system "stty #{old_state}"; exit 0; }
              execute :tail, '-f', Pathname.new(shared_path).join("log", path), "-n", args[:lines]
            end
          end
        end

      end
    end
  end

end

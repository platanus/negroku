## log.rb
#
# Dynamically adds log task based on log definitions
namespace :log do

  fetch(:negroku_logs).each do |namespace, log|

    namespace namespace do

      log.each do |name, path|

        desc "Show #{namespace} #{name} log tail"
        task name, :lines do |t, args|
          on release_roles [:app, :web] do
            within current_path do
              args.with_defaults(:lines => 10)
              execute :tail, '-f', Pathname.new(shared_path).join("log", path), "-n", args[:lines]
            end
          end
        end

      end
    end
  end

end

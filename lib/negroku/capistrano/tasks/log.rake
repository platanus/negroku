## log.rb
#
# Dynamically adds log task based on log definitions

desc "Show all logs tail"
task :logs, :lines do |t, args|
  on release_roles [:app, :web] do
    within current_path do
      paths = fetch(:negroku_logs, {}).values.map(&:values).flatten
      execute :tail, tail_args(paths, args[:lines])
    end
  end
end

namespace :logs do

  def set_tty
    old_state = `stty -g`
    system "stty -echoctl"

    trap("INT") { puts 'Bye!'; system "stty #{old_state}"; exit 0; }
  end

  def tail_args(paths, lines)
    set_tty

    args = []
    p paths
    paths.each do |path|
      args << "-f #{Pathname.new(shared_path).join("log", path)}"
    end

    args << "-n #{lines || 10}"
    args.join(' ')
  end

  fetch(:negroku_logs, {}).each do |namespace, logs|

    desc "Show #{namespace} log tail"
    task namespace, :lines do |t, args|
      on release_roles [:app, :web] do
        within current_path do
          paths = logs.map {|name, path| path}
          execute :tail, tail_args(paths, args[:lines])
        end
      end
    end

    namespace namespace do

      logs.each do |name, path|

        desc "Show #{namespace} #{name} log tail"
        task name, :lines do |t, args|
          on release_roles [:app, :web] do
            within current_path do
              execute :tail, tail_args([path], args[:lines])
            end
          end
        end

      end
    end
  end

end

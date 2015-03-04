def watch_process(name, options = {})
  processes = fetch(:eye_watched_processes, {})

  options[:template] ||= "tasks/eye/_#{name}.erb"

  processes[name] = options

  set :eye_watched_processes, processes
end

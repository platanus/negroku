def watch_process(name, roles, options={})
  processes = fetch(:eye_processes, {})

  processes[name] = options

  set :eye_processes, processes
end


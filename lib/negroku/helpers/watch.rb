def watch_process(name, template = "tasks/eye/_#{name}.erb")
  processes = fetch(:eye_watched_processes, {})

  processes[name] = {
    template: template
  }

  set :eye_watched_processes, processes
end

def watch_process(name, options = {})
  processes = fetch(:eye_watched_processes, {})

  options[:name] ||= name

  options[:template] ||= name.to_sym

  if options[:template].kind_of?(Symbol)
    options[:template] = "tasks/eye/_#{options[:template]}.erb"
  end

  processes[name] = options

  set :eye_watched_processes, processes
end

# Define los
#
def define_logs(namespace, hash)
  logs = fetch(:negroku_logs, {})

  logs[namespace] = hash

  set :negroku_logs, logs
end

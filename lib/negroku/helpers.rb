require 'negroku/helpers/logs'

# Find out if a specific library file was already required
def was_required?(file)
  rex = Regexp.new("/#{Regexp.quote(file)}\.(so|o|sl|rb)?")
  $LOADED_FEATURES.find { |f| f =~ rex }
end

def load_task(name)
  load File.join(File.dirname(__FILE__), 'tasks', "#{name}.rake")
end

# helper to build the add VAR cmd
def build_add_var_cmd(vars_file, key, value)
  puts "#{vars_file} #{key} #{value}"
  cmd = "if awk < #{vars_file} -F= '{print $1}' | grep --quiet -w #{key}; then "
  cmd += "sed -i 's/^#{key}=.*/#{key}=#{value.gsub("\/", "\\/")}/g' #{vars_file};"
  cmd += "else echo '#{key}=#{value}' >> #{vars_file};"
  cmd += "fi"
  cmd
end


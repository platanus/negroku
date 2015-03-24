# helper to build the set VAR cmd
def build_set_var_cmd(vars_file, key, value)
  puts "#{vars_file} #{key} #{value}"
  cmd = "if awk < #{vars_file} -F= '{print $1}' | grep --quiet -w #{key}; then "
  cmd += "sed -i 's/^#{key}=.*/#{key}=#{value.gsub("\/", "\\/")}/g' #{vars_file};"
  cmd += "else echo '#{key}=#{value}' >> #{vars_file};"
  cmd += "fi"
  cmd
end


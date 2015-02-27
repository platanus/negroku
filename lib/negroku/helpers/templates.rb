require "erb"

# Build the template
def build_template(template, destination, binding)

  template_file = get_template_file(template)

  result = ERB.new(template_file, nil, '-').result(binding)

  if destination
    File.open(destination.to_s, 'w+') do |f|
      f.write(result)
    end

    puts I18n.t(:written_file, scope: :negroku, file: destination)
  else
    return StringIO.new(result)
  end
end

# Render one nested error partial
def partial(filename, binding)
  template_file = get_template_file(filename)
  ERB.new(template_file, nil, '-', '_erbout2').result(binding)
end

# Get the template file from the project and fallback to the gem
def get_template_file(filename)
  if File.exists?(filename)
    templateFile = filename
  else
    templateFile = File.expand_path("../../templates/#{filename}", __FILE__)
  end

  File.read(templateFile)
end

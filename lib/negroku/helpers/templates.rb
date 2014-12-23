require "erb"

def buildTemplate(filename, destination, binding)
  template_file = getTemplateFile(filename)

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

def partial(filename, binding)
  template_file = getTemplateFile(filename)
  ERB.new(template_file, nil, '-', '_erbout2').result(binding)
end

def getTemplateFile(filename)
  File.read(File.expand_path("../../templates/#{filename}", __FILE__))
end

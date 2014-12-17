require "erb"
module Templates
  extend self

  TEMPLATE_DIR = "../../templates/negroku/"

  def buildTemplate(filename, destination, binding)
    template_file = getTemplateFile(filename)
    File.open(destination, 'w+') do |f|
      f.write(ERB.new(template_file).result(binding))
      puts I18n.t(:written_file, scope: :negroku, file: destination)
    end
  end

  private

  def getTemplateFile(filename)
    File.read(File.expand_path("#{TEMPLATE_DIR}#{filename}", __FILE__))
  end

end

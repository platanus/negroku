require 'i18n'
require 'set'

locale_path = File.join(File.dirname(__FILE__), 'locales')
I18n.load_path = Dir[File.join(locale_path, '*.yml')]
I18n.backend.load_translations

if I18n.respond_to?(:enforce_available_locales=)
  I18n.enforce_available_locales = true
end

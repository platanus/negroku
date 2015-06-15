require 'negroku/i18n'
require 'negroku/version'
require 'negroku/versionable'

module Negroku
  include Negroku::Versionable

  def self.version
    VERSION
  end

  def self.capfile_version
    defined?(::CAPFILE_VERSION).nil? ? "0.0.0" : ::CAPFILE_VERSION
  end
end

# Add requires for other files you add to your project here, so
# you just need to require this one file in your bin file

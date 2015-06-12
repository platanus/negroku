require 'bundler/setup'
Bundler.setup

require 'fakefs/safe'
require 'virtus'
require 'capistrano/all'

require 'negroku/versionable'
require 'negroku/i18n'
require 'negroku/config'
require 'negroku/modes/app'
require 'negroku/modes/stage'
require 'negroku/modes/env'
require 'negroku/helpers/app_directory'
require 'negroku/helpers/templates'

require 'negroku_mocks'

RSpec.configure do |config|
  # some (optional) config here
end

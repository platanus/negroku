require 'bundler/setup'
Bundler.setup

require 'negroku/i18n'
require 'negroku/cli/bootstrap'
require 'negroku/cli/stage'
require 'negroku/cli/env'
require 'negroku/helpers/app_directory'
require 'negroku/helpers/templates'

require "fakefs/safe"

RSpec.configure do |config|
  # some (optional) config here
end

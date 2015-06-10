require 'bundler/setup'
require 'virtus'
Bundler.setup

module Ask;end
module Capistrano
  module Application;end
  module DSL;end
end

require 'negroku/i18n'
require 'negroku/cli/bootstrap'
require 'negroku/cli/stage'
require 'negroku/cli/env'
require 'negroku/cli/config'
require 'negroku/helpers/app_directory'
require 'negroku/helpers/templates'


require "fakefs/safe"

RSpec.configure do |config|
  # some (optional) config here
end

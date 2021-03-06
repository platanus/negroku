require 'capistrano/all'
require 'capistrano/setup'
require 'capistrano/deploy'
require 'bundler'
require 'virtus'

# Load applications deploy config if it exists
require './config/deploy' if File.exists? "./config/deploy.rb"

require 'gli'
require 'inquirer'
require 'negroku/i18n'
require 'negroku/version'
require 'negroku/versionable'
require 'negroku/config'
require 'negroku/modes/app'
require 'negroku/modes/stage'
require 'negroku/modes/env'
require 'negroku/helpers/app_directory'
require 'negroku/helpers/templates'

require 'capistrano/rbenv'
require 'negroku/capistrano/deploy'

module Negroku::CLI

    extend GLI::App

    # Set th version
    version Negroku::VERSION

    # Don't show the negroku commands in the help
    hide_commands_without_desc true

    # Use the gemspec summary to describe the cli
    program_desc Gem::Specification.find_by_name('negroku').summary

    # Load all the commands in the negroku/cli/command folder
    commands_from 'negroku/cli/commands'

    # Initialize GLI app
    exit Negroku::CLI.run(ARGV)
end



require 'gli'
require 'inquirer'
require 'negroku/version'

module Negroku::CLI

    extend GLI::App

    # Set th version
    version Negroku::VERSION

    # Negroku commands will manage the interactive cli ui
    default_command :negroku

    # Don't show the negroku commands in the help
    hide_commands_without_desc true

    # Use the gemspec summary to describe the cli
    program_desc Gem::Specification.find_by_name('negroku').summary

    # Load all the commands in the negroku/cli/command folder
    commands_from 'negroku/cli/commands'

    # Initialize GLI app
    exit Negroku::CLI.run(ARGV)
end



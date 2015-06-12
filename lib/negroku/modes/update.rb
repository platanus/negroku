require 'inquirer'
require 'negroku'
require 'colorize'

module Negroku::Modes
  module Update
    def check_version
      updated = Negroku.check_version

      if(updated)
        puts I18n.t(:gem_up_to_date, scope: :negroku).colorize(mode: :bold)
      else

        puts I18n.t(:gem_new_version, scope: :negroku).colorize(mode: :bold)

        puts I18n.t(:gem_latest_version, scope: :negroku, version: Negroku.latest.colorize(:green))
        puts I18n.t(:gem_current_version, scope: :negroku, version: Negroku.version.colorize(:red))

        question = I18n.t(:continue_without_update, scope: :negroku)
        continue = ::Ask.confirm(question, default: true)

        exit 0 unless(continue)

        return continue
      end
    end

    def check_capfile_version
      updated = Negroku.check_capfile_version

      if(updated)
        puts I18n.t(:capfile_up_to_date, scope: :negroku).colorize(mode: :bold)
      else
        puts I18n.t(:capfile_new_version, scope: :negroku).colorize(mode: :bold)

        puts I18n.t(:gem_current_version, scope: :negroku, version: Negroku.version.colorize(:green))
        puts I18n.t(:capfile_current_version, scope: :negroku, version: Negroku.capfile_version.colorize(:red))

        question = I18n.t(:continue_without_update, scope: :negroku)
        continue = ::Ask.confirm(question, default: false)

        exit 0 unless(continue)
      end
    end

    def check_all_versions
      continue = self.check_version

      if(continue)
        puts I18n.t(:capfile_skip, scope: :negroku).colorize(mode: :bold)
      else
        self.check_capfile_version
      end
    end

    extend self
  end
end

require 'inquirer'
require 'colorize'
require 'negroku'

module Negroku::Modes
  module App
    def install

      check_version

      data = {}
      data[:application_name] = ask_name
      data[:repo_url] = select_repo

      ask_features

      custom_capify data
      install_binstubs

    end

    def update

      puts I18n.t :updating_capfile, scope: :negroku

      capfilePath = AppDirectory.root.join('Capfile')
      capfile = File.read(capfilePath)

      build_capfile

      capfile_new = File.read(capfilePath)

      if capfile_new != capfile
        puts I18n.t :updated_capfile, scope: :negroku
      else
        puts I18n.t :no_change_capfile, scope: :negroku
      end

    end

    def install_binstubs
      `bundle binstub capistrano negroku`
    end

    # This code was exatracted from capistrano to be used with our own templates
    # https://github.com/capistrano/capistrano/blob/68e7632c5f16823a09c324d556a208e096abee62/lib/capistrano/tasks/install.rake
    def custom_capify(data={}, config=nil)
      # defaults
      data[:server_url] = ""
      data[:branch] = "master"

      FileUtils.mkdir_p AppDirectory.deploy

      build_capfile

      deploy_rb = AppDirectory.config.join('deploy.rb')
      build_template("templates/deploy.rb.erb", deploy_rb, binding)

      FileUtils.mkdir_p AppDirectory.tasks

      puts I18n.t :capified, scope: :negroku

    end

    def build_capfile
      # Default Config
      config ||= Negroku::Config

      capfile = AppDirectory.root.join('Capfile')
      build_template('templates/Capfile.erb', capfile, binding)
    end

    # Ask the application name
    def ask_name
      question = I18n.t :application_name, scope: :negroku
      Ask.input question, default: File.basename(Dir.getwd)
    end

    def ask_features
      optional_features = Negroku::Config::attributes.select{|k,v| !v.required?}
      default_features = optional_features.map{|k,v| v.enabled?}
      features_names = optional_features.map{|k,v| v.name}

      question = I18n.t :application_features, scope: :negroku
      selected = Ask.checkbox question, features_names, default: default_features

      optional_features.each.with_index do |(idx, feat), index|
        Negroku::Config[feat.name].enabled = selected[index]
      end
    end

    # Get git remotes from current git and ask to select one
    def select_repo
      remote_urls = %x(git remote -v 2> /dev/null | awk '{print $2}' | uniq).split("\n")
      remote_urls << (I18n.t :other, scope: :negroku)

      question = I18n.t :choose_repo_url, scope: :negroku
      selected_idx = Ask.list question, remote_urls

      if selected_idx == remote_urls.length - 1
        question = I18n.t :type_repo_url, scope: :negroku
        Ask.input question
      else remote_urls[selected_idx] end
    end


    def check_version
      updated = Negroku.check_version

      if(updated)
        puts I18n.t(:gem_up_to_date, scope: :negroku).colorize(:green)
      else

        puts I18n.t(:gem_new_version, scope: :negroku).colorize(:yellow)

        puts I18n.t(:gem_latest_version, scope: :negroku, version: Negroku.latest.colorize(:green))
        puts I18n.t(:gem_current_version, scope: :negroku, version: Negroku.version.colorize(:yellow))

        puts "\n"

        gemfile_str = "Gemfile".colorize(mode: :bold)
        cmd_str = "bundle install".colorize(mode: :bold)
        puts I18n.t(:gem_update_instructions, scope: :negroku, gemfile: gemfile_str, cmd: cmd_str)

        puts "\n"

        question = I18n.t(:continue_without_update, scope: :negroku)
        continue = ::Ask.confirm(question, default: true)

        exit 0 unless(continue)

        return continue
      end
    end

    def check_capfile_version
      updated = Negroku.check_capfile_version

      if(updated)
        puts I18n.t(:capfile_up_to_date, scope: :negroku).colorize(:green)
      else
        puts I18n.t(:capfile_new_version, scope: :negroku).colorize(:red)

        puts I18n.t(:gem_current_version, scope: :negroku, version: Negroku.version.colorize(:green))
        puts I18n.t(:capfile_current_version, scope: :negroku, version: Negroku.capfile_version.colorize(:red))

        puts "\n"

        capfile_str = "Capfile".colorize(mode: :bold)
        cmd_str = "negroku app update".colorize(mode: :bold)
        puts I18n.t(:capfile_update_instructions, scope: :negroku, capfile: capfile_str, cmd: cmd_str)

        puts "\n"

        question = I18n.t(:continue_without_update, scope: :negroku)
        continue = ::Ask.confirm(question, default: false)

        exit 0 unless(continue)
      end
    end

    def check_all_versions
      continue = self.check_version

      unless(continue)
        self.check_capfile_version
      end
    end

    extend self
  end
end

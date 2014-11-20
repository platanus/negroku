require 'erb'
require 'pathname'

module Negroku::Bootstrap
  extend self

  def install

    data = {}
    data[:application_name] = ask_name
    data[:repo_url] = select_repo

    custom_capify select_stages, data

  end

  def add_stage(stage=nil)

    if stage.nil?
      name = ask_stage
    end

    custom_stage(name)

  end

  def remove_stage(stage=nil)

    current_stages = Dir[File.join(@deploy_dir, '*.rb')].map(){|f| File.basename(f)}

    if stage.nil?
      selections = Ask.checkbox "What stages you want to remove", current_stages
      stages_to_delete = selections.map.with_index { |v, i| current_stages[i] if v}.compact
    else
      stages_to_delete = ["#{stage}.rb"]
    end

    if stages_to_delete.count > 0
      stages_to_delete.each do |s|
        path_to_delete = File.join(@deploy_dir, s)
        begin
          FileUtils.rm(path_to_delete)
        rescue
          puts "The stage '#{s}' doesn't exist"
        end
      end
    else
      puts "Nothing to do"
    end

  end

  private

  @tasks_dir = Pathname.new('lib/capistrano/tasks')
  @config_dir = Pathname.new('config')
  @deploy_dir = @config_dir.join('deploy')

  @deploy_rb = File.expand_path("../../templates/negroku/deploy.rb.erb", __FILE__)
  @stage_rb = File.expand_path("../../templates/negroku/stage.rb.erb", __FILE__)
  @capfile = File.expand_path("../../templates/negroku/Capfile.erb", __FILE__)

  # This code was exatracted from capistrano to be used with our own templates
  # https://github.com/capistrano/capistrano/blob/68e7632c5f16823a09c324d556a208e096abee62/lib/capistrano/tasks/install.rake
  def custom_capify(stages, data={})

    FileUtils.mkdir_p @deploy_dir

    template = File.read(@deploy_rb)
    file = @config_dir.join('deploy.rb')
    File.open(file, 'w+') do |f|
      f.write(ERB.new(template).result(binding))
      puts I18n.t(:written_file, scope: :negroku, file: file)
    end

    template = File.read(@stage_rb)
    stages.each do |stage|
      file = @deploy_dir.join("#{stage}.rb")
      File.open(file, 'w+') do |f|
        f.write(ERB.new(template).result(binding))
        puts I18n.t(:written_file, scope: :negroku, file: file)
      end
    end

    FileUtils.mkdir_p @tasks_dir

    FileUtils.cp(@capfile, 'Capfile')


    puts I18n.t :capified, scope: :negroku

  end

  def custom_stage(stage, data={})

  end

  # Ask the application name
  def ask_name
    question = I18n.t :application_name, scope: :negroku
    Ask.input question, default: File.basename(Dir.getwd)
  end

  # Ask the stage name
  def ask_stage
    question = I18n.t :ask_stage_name, scope: :negroku
    Ask.input question
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

  # Ask which stages to setup
  def select_stages
    default_stages = %w(staging production other)

    question = I18n.t :choose_stages, scope: :negroku
    selected_idx = Ask.checkbox question, default_stages

    stages = selected_idx.map.with_index { |v, i| default_stages[i] if v}.compact

    if selected_idx.last
      question = "List the extra stages (comma separated)"
      stages[0...-1].concat (Ask.input question).split(",").map(&:strip)
    else stages end
  end

end

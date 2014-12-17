require 'erb'

module Negroku::Bootstrap
  extend self

  def install

    data = {}
    data[:application_name] = ask_name
    data[:repo_url] = select_repo

    custom_capify select_stages, data

  end


  private

  @deploy_rb = File.expand_path("../../templates/negroku/deploy.rb.erb", __FILE__)
  @stage_rb = File.expand_path("../../templates/negroku/stage.rb.erb", __FILE__)
  @capfile = File.expand_path("../../templates/negroku/Capfile.erb", __FILE__)

  # This code was exatracted from capistrano to be used with our own templates
  # https://github.com/capistrano/capistrano/blob/68e7632c5f16823a09c324d556a208e096abee62/lib/capistrano/tasks/install.rake
  def custom_capify(stages, data={})

    FileUtils.mkdir_p AppDirectory.deploy

    template = File.read(@deploy_rb)
    file = AppDirectory.config.join('deploy.rb')
    File.open(file, 'w+') do |f|
      f.write(ERB.new(template).result(binding))
      puts I18n.t(:written_file, scope: :negroku, file: file)
    end

    template = File.read(@stage_rb)
    stages.each do |stage|
      file = AppDirectory.deploy.join("#{stage}.rb")
      File.open(file, 'w+') do |f|
        f.write(ERB.new(template).result(binding))
        puts I18n.t(:written_file, scope: :negroku, file: file)
      end
    end

    FileUtils.mkdir_p AppDirectory.tasks

    FileUtils.cp(@capfile, 'Capfile')


    puts I18n.t :capified, scope: :negroku

  end

  # Ask the application name
  def ask_name
    question = I18n.t :application_name, scope: :negroku
    Ask.input question, default: File.basename(Dir.getwd)
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

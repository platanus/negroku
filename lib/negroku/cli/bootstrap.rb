module Negroku::Bootstrap
  extend self

  def install

    data = {}
    data[:application_name] = ask_name
    data[:repo_url] = select_repo

    custom_capify data

  end


  private

  # This code was exatracted from capistrano to be used with our own templates
  # https://github.com/capistrano/capistrano/blob/68e7632c5f16823a09c324d556a208e096abee62/lib/capistrano/tasks/install.rake
  def custom_capify(data={})
    # defaults
    data[:server_url] = ""
    data[:branch] = "master"

    FileUtils.mkdir_p AppDirectory.deploy

    deploy_rb = AppDirectory.config.join('deploy.rb')
    capfile = AppDirectory.root.join('Capfile')
    buildTemplate("negroku/deploy.rb.erb", deploy_rb, binding)
    buildTemplate('negroku/Capfile.erb', capfile, binding)

    FileUtils.mkdir_p AppDirectory.tasks


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

end

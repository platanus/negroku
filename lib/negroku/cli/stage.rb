module Negroku::Stage
  extend self

  def add
    config = {
      stage_name: ask_stage,
      branch: select_branch,
      domains: ask_domains,
      server_url: ask_server_url
    }

    add_stage_file config
  end

  private

  # TODO: Move to shared helper
  def buildTemplate(template, destination, binding)
    File.open(destination, 'w+') do |f|
      f.write(ERB.new(template).result(binding))
    end
  end

  # TODO: Move to shared helper
  def deploy_dir
    @config_dir = Pathname.new('config')
    @config_dir.join('deploy')
  end

  def getTemplateFile(filename)
    File.read(File.expand_path("../../templates/negroku/#{filename}", __FILE__))
  end


  def add_stage_file(data)
    template = getTemplateFile("stage.rb.erb")
    destination = deploy_dir.join("#{data[:stage_name]}.rb")

    buildTemplate(template, destination, binding)
  end

  def ask_server_url
    question = I18n.t :ask_server_url, scope: :negroku
    Ask.input question
  end

  def ask_domains
    question = I18n.t :ask_domains, scope: :negroku
    Ask.input question
  end

  def select_branch
    question = I18n.t :select_branch, scope: :negroku
    branches = get_remote_branches
    answer = Ask.list question, branches
    return branches[answer] unless branches.empty?
  end

  def get_remote_branches(fetch: false)
    %x(git fetch) if fetch

    branches = []
    %x(git branch -r).split.each do |branch|
      next unless branch.start_with? 'origin'
      branches << branch.split('/', 2)[1] unless branch =~ /HEAD/
    end
    branches.uniq
  end

  # Ask the stage name
  def ask_stage
    question = I18n.t :ask_stage_name, scope: :negroku
    Ask.input question
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
end

module Negroku::Env
  extend self

  ENV_FILE = ".rbenv-vars.example"

  def bulk(selected_stage = nil)
    if stage = selected_stage || select_stage
      variables = select_variables
      if variables.empty?
        puts I18n.t(:no_variables_added, scope: :negroku)
      else
        add_vars_to_stage(stage, variables)
      end
    end
  end

  # Adds the variables to the selected stage using cap rbenv add
  def add_vars_to_stage(stage, variables)
    # convert to array using VAR=value
    vars_array = variables.map{|k,v| "#{k}=#{v}" }
    Capistrano::Application.invoke(stage)
    Capistrano::Application.invoke("rbenv:vars:add", *vars_array)
  end

  # build a list of variables from ENV_FILE and yeilds it
  def get_variables
    return unless File.exists?(ENV_FILE)

    File.open(ENV_FILE).each do |line|
      var_name = line.split("=").first
      yield var_name unless line =~ /^\#/
    end
  end

  # Returns a hash of selected variables and values
  def select_variables
    selection = {}
    puts I18n.t(:ask_variables_message, scope: :negroku)
    get_variables do |var_name|
      selection[var_name] = Ask.input(var_name)
    end
    selection.reject {|key, value| value.empty? }
  end

  def select_stage
    if current_stages.empty?
      puts I18n.t(:no_stages_found, scope: :negroku)
    else
      selection = Ask.list I18n.t(:select_stages_question, scope: :negroku), current_stages
      current_stages[selection]
    end
  end

  def current_stages
    @current_stages ||= Capistrano::Application.stages
  end
end

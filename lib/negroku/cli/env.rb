module Negroku::Env
  extend self

  def bulk
    if stage = select_stage
      variables = select_variables
      if variables.empty?
        puts I18n.t(:no_variables_added, scope: :negroku)
      else
        add_vars_to_stage(stage, variables)
      end
    end
  end

  private

  # Adds the variables to the selected stage using cap rbenv add
  def add_vars_to_stage(stage, variables)
    # convert to array using VAR=value
    vars_array = variables.map{|k,v| "#{k}=#{v}" }
    Capistrano::Application.invoke(stage)
    Capistrano::Application.invoke("rbenv:vars:add", *vars_array)
  end

  def select_variables
    vars = {}
    if File.exists?(".rbenv-vars")
      puts I18n.t(:ask_variables_message, scope: :negroku)
      File.open(".rbenv-vars").each do |line|
        var_name = get_var_name(line)
        vars[var_name] = Ask.input("#{var_name}") unless line =~ /^\#/
      end
    else
      puts I18n.t(:rbenv_vars_not_found, scope: :negroku)
    end
    vars.reject {|key, value| value.empty? }
  end

  def get_var_name(line)
    line.split("=").first
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

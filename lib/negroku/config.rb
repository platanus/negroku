module Negroku
  class Feature
    include Virtus.value_object

    values do
      attribute :name, String
      attribute :required, Boolean, default: false
      attribute :enabled, Boolean, default: false, :writer => :public
    end
  end
end

class Negroku::ConfigFactory
  include Virtus.model

  def self.loaded_in_bundler(*names)
    Bundler.locked_gems.dependencies.any? { |a| names.include?(a.name) }
  end

  attribute :bower, Negroku::Feature, default: {
    name: "bower", enabled: File.exists?('bower.json')
  }

  attribute :bundler, Negroku::Feature, default: {
    name: "bundler", enabled: File.exists?('Gemfile')
  }

  attribute :delayed_job, Negroku::Feature, default: {
    name: 'delayed_job',
    enabled: loaded_in_bundler('delayed_job', 'delayed_job_active_record')
  }

  attribute :nginx, Negroku::Feature, default: {
    name: "nginx", enabled: true, required: true
  }

  attribute :nodenv, Negroku::Feature, default: {
    name: "nodenv", enabled: true, required: true
  }

  attribute :rails, Negroku::Feature, default: {
    name: "rails", enabled: loaded_in_bundler('rails')
  }

  attribute :rbenv, Negroku::Feature, default: {
    name: "rbenv", enabled: true, required: true
  }

  attribute :sphinx, Negroku::Feature, default: {
    name: "sphinx", enabled: loaded_in_bundler('thinking-sphinx')
  }

  attribute :unicorn, Negroku::Feature, default: {
    name: "unicorn", enabled: loaded_in_bundler('unicorn')
  }

  attribute :puma, Negroku::Feature, default: {
    name: "puma", enabled: loaded_in_bundler('puma')
  }

  attribute :whenever, Negroku::Feature, default: {
    name: "whenever", enabled: File.exists?('config/schedule.rb')
  }

  # private

end

Negroku::Config = Negroku::ConfigFactory.new

module Negroku::Versionable
  module ClassMethods
    attr_accessor :latest, :capfile_version, :updated, :capfile_updated

    def check_version
      require 'gems'

      self.latest = Gems.versions("negroku").first["number"]
      self.updated = is_latest?(version, self.latest)
    end

    def check_capfile_version
      self.capfile_updated = is_latest?(capfile_version, version)
    end

    private

    def is_latest?(current_version, latest_version)
      require 'semantic'

      latest_version = Semantic::Version.new latest_version
      current_version = Semantic::Version.new current_version

      latest_version <= current_version
    end
  end

  def self.included klass
    klass.extend ClassMethods
  end
end

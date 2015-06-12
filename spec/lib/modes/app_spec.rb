require "spec_helper"

describe "app cli" do

  describe "install cmd" do

    before(:each) do
      FakeFS::FileSystem.clear
      FakeFS::FileSystem.clone(File.join('lib','negroku','templates'))
      FakeFS::FileSystem.clone(File.join('lib','negroku','locales'))
      FakeFS.activate!

      Dir.mkdir("config")
      Dir.mkdir("config/deploy")

      allow(Ask).to receive(:checkbox).and_return([true, false, true])

      expect(Negroku::Modes::App).to receive(:select_repo).and_return("git.repo.url")
      expect(Negroku::Modes::App).to receive(:ask_name).and_return("NewApp")

    end

    after(:each) do
      FakeFS.deactivate!
    end

    it "creates the deploy.rb" do
      Negroku::Modes::App.install

      expect(File).to exist("config/deploy.rb")
      content = File.read("config/deploy.rb")
      expect(content).to match(/set :application,\s+'NewApp'/)
      expect(content).to match(/set :repo_url,\s+'git.repo.url'/)
    end

    it "generate the Capfile" do
      Negroku::Modes::App.install

      expect(File).to exist("Capfile")
      content = File.read("Capfile")

      expect(content).to match(/^#require 'capistrano3\/unicorn'/)
      expect(content).to match(/^require 'capistrano\/rbenv'/)
    end

  end
end

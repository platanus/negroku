require "spec_helper"

describe "bootstrap cli" do

  describe "install cmd" do

    context "bootstrap app" do

      before(:each) do
        FakeFS::FileSystem.clear
        FakeFS::FileSystem.clone(File.join('lib','negroku','templates'))
        FakeFS::FileSystem.clone(File.join('lib','negroku','locales'))
        FakeFS.activate!

        Dir.mkdir("config")
        Dir.mkdir("config/deploy")

        allow(Ask).to receive(:checkbox).and_return([true, false, true])

        expect(Negroku::Bootstrap).to receive(:select_repo).and_return("git.repo.url")
        expect(Negroku::Bootstrap).to receive(:ask_name).and_return("NewApp")

      end

      after(:each) do
        FakeFS.deactivate!
      end

      it "creates the deploy.rb" do
        Negroku::Bootstrap.install

        expect(File).to exist("config/deploy.rb")
        content = File.read("config/deploy.rb")
        expect(content).to match(/set :application,\s+'NewApp'/)
        expect(content).to match(/set :repo_url,\s+'git.repo.url'/)
      end

      it "copies the Capfile" do
        Negroku::Bootstrap.install

        expect(File).to exist("Capfile")
      end

    end
  end
end

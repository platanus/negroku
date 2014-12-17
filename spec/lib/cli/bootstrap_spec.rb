require "spec_helper"

module Ask;end

describe "bootstrap cli" do

  describe "install cmd" do
    context "stage files" do
      before(:each) do
        FakeFS::FileSystem.clear
        FakeFS::FileSystem.clone(File.join('lib','negroku','templates'))
        FakeFS::FileSystem.clone(File.join('lib','negroku','locales'))
        FakeFS.activate!

        Dir.mkdir("config")
        Dir.mkdir("config/deploy")

        expect(Negroku::Bootstrap).to receive(:select_repo).and_return("git.repo.url")
        expect(Negroku::Bootstrap).to receive(:ask_name).and_return("NewApp")
        expect(Negroku::Bootstrap).to receive(:select_stages).and_return(%w(alpha beta))

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


      it "creates the stage files" do
        Negroku::Bootstrap.install

        expect(File).to exist("config/deploy/alpha.rb")
        expect(File).to exist("config/deploy/beta.rb")
        content = File.read("config/deploy/alpha.rb")
        expect(content).to match(/ALPHA CONFIGURATION/)
        expect(content).to match(/server ''/)
        expect(content).to match(/set :branch,\s+'master'/)
        expect(content).to match(/set :nginx_domains,\s+''/)
      end
    end
  end
end

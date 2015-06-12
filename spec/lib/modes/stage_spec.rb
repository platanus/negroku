require "spec_helper"

describe "stage cli" do

  context "add command" do

    before(:each) do
      allow_any_instance_of(Negroku::Modes::Stage).to receive(:deploy_config_path)
    end

    it "fails with no stage name defined" do
      allow(Ask).to receive(:input).and_return("")
      expect{Negroku::Modes::Stage.add}.to raise_error(/required/)
    end

    it "calls negroku env bulk if chosen" do
      allow(Negroku::Modes::Stage).to receive(:ask_stage).and_return("deleteme")
      allow(Negroku::Modes::Stage).to receive(:select_branch).and_return("master")
      allow(Negroku::Modes::Stage).to receive(:ask_domains).and_return("www")
      allow(Negroku::Modes::Stage).to receive(:ask_server_url).and_return("server_url")
      allow(Negroku::Modes::Stage).to receive(:add_stage_file)
      allow_any_instance_of(Negroku::Modes::Stage).to receive(:load)

      expect(Negroku::Modes::Stage).to receive(:ask_set_vars).and_return(true)
      expect(Negroku::Modes::Env).to receive(:bulk).with("deleteme")

      expect{Negroku::Modes::Stage.add}.not_to raise_error
    end

    it "creates the stage file" do
      config = {
        stage_name: "new_stage",
        branch: "test",
        domains: "test.platan.us",
        server_url: "server.url"
      }
      FakeFS::FileSystem.clear
      FakeFS::FileSystem.clone(File.join('lib','negroku'))
      FakeFS.activate!
      Dir.mkdir("config")
      Dir.mkdir("config/deploy")

      Negroku::Modes::Stage.add_stage_file(config)

      expect(File).to exist("config/deploy/new_stage.rb")
      content = File.read("config/deploy/new_stage.rb")
      expect(content).to match(/NEW_STAGE CONFIGURATION/)
      expect(content).to match(/server 'server.url'/)
      expect(content).to match(/set :branch,\s+'test'/)
      expect(content).to match(/set :nginx_domains,\s+'test.platan.us'/)

      FakeFS.deactivate!
    end

  end

  context "#get_remote_branches" do
    it "gets the remote branches" do
      branches = %q(
        origin/HEAD -> origin/master
        origin/master
        origin/staging
      )
      expect(Negroku::Modes::Stage).to receive(:`).with('git branch -r').and_return(branches)

      branches = Negroku::Modes::Stage.get_remote_branches
      expect(branches.size).to eq 2
      expect(branches).to include("master")
      expect(branches).to include("staging")
    end

    it "returns an empty array if the command fails" do
      branches = ""
      expect(Negroku::Modes::Stage).to receive(:`).with('git branch -r').and_return(branches)

      branches = Negroku::Modes::Stage.get_remote_branches
      expect(branches.size).to eq 0
    end

  end

end

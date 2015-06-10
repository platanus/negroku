require "spec_helper"

describe "env cli" do
  describe "bulk cmd" do
    before(:each) do
      FakeFS::FileSystem.clear
      FakeFS.activate!
      File.open(".rbenv-vars.example", "w") do |file|
        file.puts "#COMMENTED=HI"
        file.puts "SERVER=platan.us"
        file.puts "PASSWORD=oops"
      end
    end

    after(:each) do
      FakeFS.deactivate!
    end

    it "asks for stage if not selected" do
      expect(Negroku::Env).to receive(:select_stage)

      Negroku::Env.bulk
    end

    it "use selected stage if passed" do
      allow(Negroku::Env).to receive(:select_variables).and_return([])
      expect(Negroku::Env).not_to receive(:select_stage)

      Negroku::Env.bulk "beta"
    end

    it "selects the stage and calls rbenv:vars:set with the vars" do
      allow(Negroku::Env).to receive(:select_variables).and_return({USER: "emilio", PASSWORD: "123"})
      expect(Capistrano::Application).to receive(:invoke).with("beta")
      expect(Capistrano::Application).to receive(:invoke).with("rbenv:vars:set", "USER=emilio", "PASSWORD=123")

      Negroku::Env.bulk "beta"
    end

    it "returns the list of variables" do
      expect{|b| Negroku::Env.get_variables(&b)}.to yield_control.twice
    end
  end
end

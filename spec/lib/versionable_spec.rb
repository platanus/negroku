require "spec_helper"

describe Negroku::Versionable do

  describe "when version is checked" do

    let(:test_version){ "2.4.2" }

    before(:each) do
      allow(Gems).to receive(:versions).and_return([{"number" => test_version}])
      Negroku.check_version
    end

    it "should set the latest version" do
      expect(Negroku.latest).to match("2.4.2")
    end

    describe "and is updated" do

      it "should set updated status to true" do
        expect(Negroku.updated).to be(true)
      end

    end

    describe "and is out-dated" do

      let(:test_version){ "2.4.3" }

      it "should set updated status to false" do
        expect(Negroku.updated).to be(false)
      end

    end
  end

  describe "when Capfile version is checked" do

    before(:each) do
      Negroku.check_capfile_version
    end

    describe "and Capfile does have a version" do

      let(:capfile_version){ "2.4.2" }

      before(:each) do
        stub_const("CAPFILE_VERSION", capfile_version)
        Negroku.check_capfile_version
      end

      it "should set the capfile version" do
        expect(Negroku.capfile_version).to match(Negroku.version)
      end

      describe "and is updated" do

        it "should set capfile updated status to true" do
          expect(Negroku.capfile_updated).to be(true)
        end

      end

      describe "and is out-dated" do

        let(:capfile_version){ "2.4.1" }

        it "should set capfile updated status to false" do
          expect(Negroku.capfile_updated).to be(false)
        end

      end

    end

    describe "and Capfile doesn't have a version" do

      it "should set the capfile version" do
        expect(Negroku.capfile_version).to match("0.0.0")
      end

      it "should set capfile updated status to false" do
        expect(Negroku.capfile_updated).to be(false)
      end

    end
  end
end

require "spec_helper"

describe Build, "-" do

  def test_json
    # create json hash
    json = {}
    json["duration"] = 1;
    json["fullDisplayName"] = "Mr Test"
    json["result"] = true
    json["number"] = 1
    json["url"] = "http://test.com"
    json["id"] = "2012-11-06_01-00-32"
    json["changeSet"] = {"items" => [{"id" => 1}]}
    json
  end

  before do
    Build.any_instance.stub(:save) {true}
  end

  describe "When parsing" do

    it "should return nil if the build is building" do
      job = double("job")
      json = test_json
      json["building"] = true
      test_build = Build.from_api_response(json)

      test_build.should eq(nil)
    end

  end

  describe "When creating a Build object from JSON" do

    before do
      Commit.stub(:save)
    end

    def test_job
      FactoryGirl.build(:job)
    end

    def test_build
      Build.from_api_response(test_json)
    end

    it "should assign duration" do
      test_build.duration.should eq(1)
    end

    it "should assign a url" do
      test_build.url.should eq("http://test.com")
    end

    it "should assign name" do
      test_build.name.should eq("Mr Test")
    end

    it "should assign success" do
      test_build.success.should eq(true)
    end

    it "should assign number" do
      test_build.number.should eq(1)
    end

    it "should assing a date" do
      test_build.date.day.should eq(6)
      test_build.date.year.should eq(2012)
      test_build.date.month.should eq(11)
    end

    it "should create a commit object if there is a response" do
      Commit.stub(:from_api_response){FactoryGirl.build(:commit)}
      Developer.stub(:developers_from_api_response)

      Commit.should_receive(:from_api_response).exactly(1).times
      test_build
    end

  end

  describe "When parsing developers" do

    before do
      Developer.stub(:update_attributes) {true}
    end

    it "should assign developers when build fails" do
      developer = FactoryGirl.build(:developer)
      Developer.stub(:developers_from_api_response) {[developer]}

      test_build = FactoryGirl.build(:build, success: false)
      Build.stub(:new){test_build}

      build = Build.from_api_response("")
      build.developers.should include(developer)
    end

    it "should not assign developers when build succeeds" do
      Build.any_instance.stub(:success) {true}
      test_build = FactoryGirl.build(:build)
      test_build.developers.should be_empty
    end

  end

  describe "After saving" do

    def report_json
      json = {}
      json["passCount"] = 1
      json
    end

    def garbage_response
      "oajdfipsjgsifg"
    end

    before do
      response = ""
      response.stub(:code){200}
      HTTParty.stub(:get){response}
    end

    it "should increment developer counts when build has developers" do
      build = FactoryGirl.build(:build, success: false)
      build.developers = [FactoryGirl.build(:developer)]
      build.should_receive(:increment_developers_broken_build_count).exactly(1).times

      build.save!
    end

    it "should not increment developer counts when build has no developers" do
      Developer.stub(:developers_from_api_response) {[]}
      build = FactoryGirl.build(:build, success: false)
      Build.stub(:new){build}

      build.should_receive(:increment_developers_count).exactly(0).times
      test_build = FactoryGirl.build(:build)
      test_build.save!
    end

    it "should not increment developer counts for succesful builds before save" do
      Developer.stub(:developers_from_api_response) {[]}
      build = FactoryGirl.build(:build, success: true)
      Build.stub(:new){build}

      build.should_receive(:increment_developers_count).exactly(0).times
      test_build = FactoryGirl.build(:build)
      test_build.save!
    end

    it "should increment developer counts for failed builds" do
      developer = FactoryGirl.build(:developer, broken_build_count: 1)

      test_build = FactoryGirl.build(:build, success: false)
      test_build.developers = [developer]

      test_build.should_receive(:increment_developers_broken_build_count)
      test_build.update_developers
    end

    it "should add one to the existing developer count" do
      developer = FactoryGirl.build(:developer, broken_build_count: 1)
      developer.should_receive(:update_attributes).with(:broken_build_count => 2)

      test_build = FactoryGirl.build(:build)
      test_build.developers = [developer]

      test_build.increment_developers_broken_build_count
    end

    it "should request the builds test report" do
      HTTParty.stub(:get){report_json}
      US2::Jenkins.any_instance.should_receive(:get_test_report)
      build = FactoryGirl.build(:build, success: true)
      build.stub(:update_developers)
      build.save!
    end

    describe "When a test report is found" do

      it "should not do anything with a nil report" do
        report = FactoryGirl.build(:test_report)
        US2::Jenkins.any_instance.stub(:get_test_report).and_yield(nil)

        build = FactoryGirl.build(:build, success: true)

        report.should_not_receive(:build=)
        report.should_not_receive(:save!)

        build.stub(:update_developers)
        build.save!
      end

      it "should assign itself to the test report" do
        report = FactoryGirl.build(:test_report)
        US2::Jenkins.any_instance.stub(:get_test_report).and_yield(report)

        build = FactoryGirl.build(:build, success: true)

        report.should_receive(:build=).with(build)
        build.stub(:update_developers)
        build.save!
      end

      it "should save the report" do
        report = FactoryGirl.build(:test_report)
        US2::Jenkins.any_instance.stub(:get_test_report).and_yield(report)

        report.should_receive(:save!)

        build = FactoryGirl.build(:build, success: true)
        build.stub(:update_developers)
        build.save!
      end

    end

  end

  describe "When returning responses" do

    it "should return a health response" do
      build = FactoryGirl.build(:build, success: true)
      build.health_response.should_not eq(nil)
    end

    it "should return average duration" do
      build = FactoryGirl.build(:build, success: true)
      build.job = Job.new(:name => "test")
      build.stub(:date){DateTime.now}
      Build.duration_response_for_builds([build]).should_not eq(nil)
    end

    it "should return average duration correctly" do
      build = FactoryGirl.build(:build, success: true)
      build.job = Job.new(:name => "test")
      time = DateTime.now
      build.stub(:date){time}
      build.stub(:duration){1000}
      response = Build.duration_response_for_builds([build])

      response.first[:date].should eq(time.to_date.to_s)
      response.first["test"].should eq(1)
    end

  end

  describe "When grouping" do
    it "should group by day" do
      build = FactoryGirl.build(:build, success: true)
      build.should respond_to(:group_by_day)
    end
  end

end

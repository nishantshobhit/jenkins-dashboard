require "spec_helper"

describe Job, "-" do

  def test_json
    json = {}
    json["name"] = "Test Job"
    json["url"] = "http://google.com"
    json["color"] = "red" # will equal :broken
    json
  end

  def test_json_invalid_color
    json = {}
    json["name"] = "Test Job"
    json["url"] = "http://google.com"
    json["color"] = "brown" # will equal :unkown
    json
  end

  before do
    Job.any_instance.stub(:update_attributes){true}
    Job.any_instance.stub(:save){true}
    HTTParty.stub(:get){"response string"}
  end

  describe "When parsing jobs json" do

    it "should set a name" do
      job = Job.from_api_response(test_json)
      job.name.should eq("Test Job")
    end

    it "should set a status from color json" do
      job = Job.from_api_response(test_json)
      job.status_name.should eq(:broken)
    end

    it "should handle an unkown status color" do
      job = Job.from_api_response(test_json_invalid_color)
      job.status_name.should eq(:unknown)
    end

    it "should set a url" do
      job = Job.from_api_response(test_json)
      job.url.should eq("http://google.com")
    end

    it "should create a new job when the job is new" do
      test_job = FactoryGirl.build(:job)
      Job.stub(:new){test_job}
      Job.stub(:find){[]}
      # parse
      Job.from_api_response(test_json).should eq(test_job)
    end

    it "should update the existing jobs color if it is in the database" do
      test_job = FactoryGirl.build(:job)
      Job.stub(:find){[test_job]}

      # test
      test_job.should_receive(:status=).with("red")
      # parse
      Job.from_api_response(test_json)
    end

  end

  describe "When queried" do

    before do
      @test_job = FactoryGirl.build(:job)
      @test_build = FactoryGirl.build(:build)
      @test_builds = [@test_build]
      @test_commit = FactoryGirl.build(:commit)
      @test_developer = FactoryGirl.build(:developer)
      @test_report = FactoryGirl.build(:test_report)

      @test_developer.stub(:id){1}
      @test_commit.stub(:developer){@test_developer}
      @test_build.stub(:commits){[@test_commit]}
      @test_build.stub(:test_report){@test_report}
      @test_builds.stub(:where){@test_builds}
      @test_builds.stub(:joins){@test_builds}
      @test_job.stub(:builds){@test_builds}
      @test_builds.stub(:count){1}
      Build.stub_chain(:includes){@test_builds}
    end

    it "should return its developers" do
      @test_job.developers.first.id.should eq(1)
    end

    it "should calculate its total lines" do
      @test_job.total_lines.should eq(0)
    end

    it "should count it's successful builds" do
      @test_job.successful_builds.should eq(1)
    end

    it "should return the latest build" do
      test_build = FactoryGirl.build(:build, :number => 0)
      test_build1 = FactoryGirl.build(:build, :number => 1)
      test_build2 = FactoryGirl.build(:build, :number => 2)
      Array.any_instance.stub(:sort!){[test_build2, test_build1, test_build]}
      @test_job.latest_build.number.should eq(2)
    end

    it "should count it's failed builds" do
      @test_job.failed_builds.should eq(1)
    end

    it "should count it's deletions" do
      @test_job.deletions.should eq(1)
    end

    it "should count it's insertions" do
      @test_job.insertions.should eq(1)
    end

    it "should count it's skipped tests" do
      @test_job.skipped_tests.should eq(20)
    end

    it "should count it's failed tests" do
      @test_job.failed_tests.should eq(10)
    end

    it "should count it's passed tests" do
      @test_job.passed_tests.should eq(100)
    end

    it "should not return null passed tests" do
      @test_report.stub(:passed){nil}
      @test_job.passed_tests.should eq(0)
    end

    it "should not return null failed tests" do
      @test_report.stub(:failed){nil}
      @test_job.failed_tests.should eq(0)
    end

    it "should not return null skipped tests" do
      @test_report.stub(:skipped){nil}
      @test_job.skipped_tests.should eq(0)
    end

    it "should not return null most commits" do
      @test_job.stub(:developers){[]}
      @test_job.most_commits.should match("unknown")
    end

    it "should get the developer with most broken builds" do
      @test_job.build_breaker.should eq("Test")
    end

    it "should get the developer with most commits" do
      @test_job.most_commits.should eq("Test")
    end

  end

end

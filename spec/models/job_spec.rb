require "spec_helper"

describe Job, "-" do

  def test_json
    json = {}
    json["name"] = "Test Job"
    json["url"] = "http://google.com"
    json["color"] = "red" # will equal :broken
    json
  end

  before do
    Job.any_instance.stub(:update_attributes){true}
    Job.any_instance.stub(:save){true}
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

      @test_developer.stub(:id){1}
      @test_commit.stub(:developer){@test_developer}
      @test_build.stub(:commits){[@test_commit]}
      @test_builds.stub(:where){@test_builds}
      @test_job.stub(:builds){@test_builds}
    end

    it "should return its developers" do
      @test_job.developers.first.id.should eq(1)
    end

    it "should calculate its total lines" do
      @test_job.stub(:insertions){100}
      @test_job.stub(:deletions){50}

      @test_job.total_lines.should eq(50)
    end

    it "should count it's successful builds" do
      @test_job.successful_builds.should eq(1)
    end

    it "should count it's failed builds" do
      @test_job.failed_builds.should eq(1)
    end

    it "should count it's deletions" do
      @test_commit.stub(:deletions){100}

      @test_job.deletions.should eq(100)
    end
  end

end

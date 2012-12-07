require "spec_helper"

describe US2::Jenkins, "-" do

  def jenkins
    US2::Jenkins.instance
  end

  def jobs_json
    jobs = {}
    jobs["jobs"] = [job_json]
    jobs
  end

  def job_json
    job = {}
    job["name"] = "test"
    job["color"] = "blue"
    job["url"] = "http://google.com"
    job["builds"] = builds_json
    job.stub(:code){200}
    job
  end

  def builds_json
    build = {}
    build["url"] = "http://test.com"
    build2 = {}
    build2["url"] = "http://blah.com"
    [build,build2]
  end

  def test_job
    FactoryGirl.build(:job, name: "test", status: "red", url: "test4")
  end

  describe "When initialized" do

    it "Should be a singleton" do
      jenkins.should_not eq(nil)
    end

  end

  describe "When syncing" do

    before do
      HTTParty.stub(:get){jobs_json}
      jenkins.stub(:get_latest_build)
      jenkins.stub(:latest_build_url)
    end

    it "should create a job from the response" do
      Job.stub(:from_api_response){test_job}
      Job.should_receive(:from_api_response)
      jenkins.sync
    end

    it "should get the latest build for each job" do
      job = test_job
      test_jenkins = US2::Jenkins.new()
      test_jenkins.stub(:jobs){[job]}
      test_jenkins.should_receive(:get_latest_build).with(job)
      test_jenkins.sync
    end

  end

  describe "When populating" do

    it "should get all of each jobs builds" do
      job = test_job
      job.stub(:get_all_builds)

      jenkins.stub(:jobs){[job]}
      jenkins.should_receive(:get_all_builds)
      jenkins.populate
    end

  end

  describe "When getting builds" do

    def build_json
      build = {}
      build["url"] = "http://test.com"
      build.stub(:code){200}
      build
    end

    before do
      HTTParty.stub(:get){build_json}
      Build.stub(:from_api_response){FactoryGirl.build(:build)}
    end

    it "should create a Build object and return it in a block" do
      test_job = FactoryGirl.build(:job)
      Build.should_receive(:from_api_response).with(build_json)
      jenkins.get_latest_build(test_job) do |build|
        build.should_not eq(nil)
      end
    end

    it "should create an array of Build objects and return them in a block" do
      test_job = FactoryGirl.build(:job)

      jenkins.stub(:build_urls) {["www.google.com","www.yahoo.com"]}
      Build.stub(:from_api_response) {FactoryGirl.build(:build, url: "www.google.com")}

      jenkins.get_all_builds(test_job) do |builds|
        builds.length.should eq(2)
        builds.first.url.should eq("www.google.com")
      end
    end

    it "should not return nil builds in the array" do
      test_job = FactoryGirl.build(:job)

      Build.stub(:from_api_response) {nil}

      jenkins.get_all_builds(test_job) do |builds|
        builds.length.should eq(0)
      end
    end

  end

  describe "When getting the builds url from a job" do

    before do
      HTTParty.stub(:get){job_json}
    end

    it "should respond with the latest build url" do
      test_job = Job.new()
      jenkins.instance_eval{latest_build_url(test_job)}.should eq("http://test.com")
    end

    it "should only respond with the first build url" do
      test_job = Job.new()
      jenkins.instance_eval{latest_build_url(test_job)}.should_not eq("http://blah")
    end

    it "should respond with all the build urls" do
      test_job = Job.new()
      jenkins.instance_eval{build_urls(test_job)}.length.should eq(2)
    end

  end

  describe "When getting test reports" do

    def report_json
      json = {}
      json["passCount"] = 1
      json.stub(:code){200}
      json
    end

    def garbage_response
      garbage = "oajdfipsjgsifg"
      garbage.stub(:code){200}
      garbage
    end

    def test_build
      Build.new(:id => 1, :url => "http://test.com")
    end

    it "should create a test report from the response" do
      HTTParty.stub(:get){report_json}
      test_report = TestReport.new()
      TestReport.stub(:from_api_response){test_report}
      TestReport.should_receive(:from_api_response)

      test_build = FactoryGirl.build(:build)
      jenkins.get_test_report(test_build) do |report|
      end
    end

    it "should not attempt to parse a garbage test report response" do
      HTTParty.stub(:get){garbage_response}
      TestReport.should_receive(:from_api_response).exactly(0).times

      test_build = FactoryGirl.build(:build)
      jenkins.get_test_report(test_build) do |report|
      end
    end

    it "should return false if the build has no test report" do
      garbage = garbage_response
      jenkins.instance_eval{build_response_has_test_report(garbage)}.should eq(false)
    end

    it "should return true if the build has a test report" do
      report = report_json
      jenkins.instance_eval{build_response_has_test_report(report)}.should eq(true)
    end

  end

end

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
    job
  end
  
  def builds_json
    build = {}
    build["url"] = "http://test.com"
    build2 = {}
    build2["url"] = "http://blah.com"
    [build,build2]
  end
  
  describe "When initialized" do
    
    it "Should be a singleton" do
      jenkins.should_not eq(nil)
    end
    
  end
  
  describe "When getting jobs" do
    
    def test_job
      Job.new(:name => "test", "status" => "red", "url" => "test4")
    end
    
    before do
      HTTParty.stub(:get){jobs_json}
      jenkins.stub(:get_latest_build)
      jenkins.stub(:latest_build_url)
    end
    
    it "should create a job from the response" do
      Job.stub(:from_api_response){test_job}
      Job.should_receive(:from_api_response)
      jenkins.get_jobs
    end
    
    it "should get the latest build for each job" do
      job = test_job
      Job.stub(:from_api_response){job}
      jenkins.should_receive(:get_latest_build).with(job)
      jenkins.get_jobs
    end
    
  end
  
  describe "When getting the latest build" do
      
    def build_json
      build = {}
      build["url"] = "http://test.com"
      build
    end
    
    before do
      HTTParty.stub(:get){build_json}
      Build.stub(:from_api_response){Build.new()}
    end
    
    it "should create a Build object and return it in a block" do
      test_job = Job.new()
      Build.should_receive(:from_api_response).with(build_json,test_job)
      jenkins.get_latest_build(test_job) do |build|
        build.should_not eq(nil)
      end
    end
    
  end
  
  describe "When getting the latest build url from a job" do
    
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
  
  end
  
  describe "When getting test reports" do
    
    def report_json
      json = {}
      json["passCount"] = 1
      json  
    end
    
    def garbage_response
      "oajdfipsjgsifg"
    end
    
    def test_build
      Build.new(:id => 1, :url => "http://test.com")
    end
    
    it "should create a test report from the response" do
      HTTParty.stub(:get){report_json}
      test_report = TestReport.new()
      TestReport.stub(:from_api_response){test_report}
      TestReport.should_receive(:from_api_response)
      
      test_build = Build.new()
      jenkins.get_test_report(test_build) do |report|
      end
    end
    
    it "should not attempt to parse a garbage test report response" do
      HTTParty.stub(:get){garbage_response}
      TestReport.should_receive(:from_api_response).exactly(0).times
      
      test_build = Build.new()
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
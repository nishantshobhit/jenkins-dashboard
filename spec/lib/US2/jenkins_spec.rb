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
    
    before do
      HTTParty.stub(:get){jobs_json}
      jenkins.stub(:get_latest_build)
      jenkins.stub(:latest_build_url)
    end
    
    it "should create a job from the response" do
      Job.should_receive(:from_api_response)
      jenkins.get_jobs
    end
    
    it "should get the latest build for each job" do
      test_job = Job.new()
      Job.stub(:from_api_response){test_job}
      jenkins.should_receive(:get_latest_build).with(test_job)
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
    
    it "should return false if the build has no test report" do
      jenkins.build_response_has_test_report(garbage_response).should eq(false)
    end
    
    it "should return true if the build has a test report" do
      jenkins.build_response_has_test_report(report_json).should eq(true)
    end
    
  end
  
end
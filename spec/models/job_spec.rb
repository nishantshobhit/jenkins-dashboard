require "spec_helper"

describe Job, "-" do
  
  def test_json
    json = {}
    json["name"] = "Test Job"
    json["url"] = "http://google.com"
    json["color"] = "red" # will equal :broken
    json
  end 
  
  def test_job
    Job.new(:name => "test", "status" => "red", "url" => "test4")
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
      test_job = Job.new()
      Job.stub(:new){test_job}
      Job.stub(:find){[]}
      # parse
      Job.from_api_response(test_json).should eq(test_job)
    end
    
    it "should update the existing jobs color if it is in the database" do
      test_job = Job.new()
      Job.stub(:find){[test_job]}
      
      # test
      test_job.should_receive(:status=).with("red")
      # parse
      Job.from_api_response(test_json)
    end
    
  end
  
  describe "After saving" do
    
    it "should update its latest build" do
      job = test_job
      job.should_receive(:get_latest_build)
      job.save!
    end
    
  end
  
end 
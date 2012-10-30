require "spec_helper"

describe Build, "When Parsing" do
  
  def test_json
    # create json hash
    json = {}
    json["duration"] = 1;
    json["fullDisplayName"] = "Mr Test"
    json["result"] = true
    json["number"] = 1
    json
  end
  
  before do
    Build.any_instance.stub(:save) {true}
  end
  
  it "should return nil if the build is already in the database" do
    build = double("build")
    job = double("job")
    Build.any_instance.stub(:is_in_database) {true}
    test_build = Build.from_api_response(test_json,job)
    
    test_build.should eq(nil)
  end
  
  it "should assign a job when parsing" do
    job = Job.new()
    test_build = Build.from_api_response(test_json,job)
    test_build.job.should_not eq(nil)
  end
  
  #
  describe "When parsing culprits" do
    
    before do
      Build.any_instance.stub(:is_in_database) {false}
    end
      
    it "should assign culprits when build success is false" do
      culprit = Culprit.new()      
      Culprit.stub(:culprits_from_api_response) {[culprit]}
      
      Build.any_instance.stub(:success) {false}
    
      job = Job.new()
      test_build = Build.from_api_response(test_json,job)
      test_build.culprits.should include(culprit)
    end
  
    it "should not assign culprits when build success is true" do
      Build.any_instance.stub(:success) {true}
    
      job = Job.new()
      test_build = Build.from_api_response(test_json,job)
      test_build.culprits.should be_empty
    end
    
  end
  
end
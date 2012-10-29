require "spec_helper"

describe Build, "When Parsing" do
  
  # create json hash
  json = {}
  json["duration"] = 1;
  json["fullDisplayName"] = "Mr Test"
  json["result"] = true
  json["number"] = 1
  
  it "should return nil if the build is already in the database" do
    build = double("build")
    job = double("job")
    Build.any_instance.stub(:is_in_database) {true}
    
    test_build = Build.from_api_response(json,job)
    
    test_build.should eq(nil)
  end
end
require 'spec_helper'

describe TestReport do
  
  def response
    json = {}
    json["passCount"] = 1
    json["failCount"] = 1
    json["duration"] = 100
    json["skipCount"] = 0
    json
  end
  
  describe "When parsing" do
    
    it "should return a TestReport object" do
      TestReport.from_api_response(response).should_not eq(nil)
    end
    
    it "should return nil for invalid json" do
      TestReport.from_api_response("asdfasdf").should eq(nil)
    end
    
    it "should set a pass count" do
      report = TestReport.from_api_response(response)
      report.passed.should eq(1)
    end
    
    it "should set a fail count" do
      report = TestReport.from_api_response(response)
      report.failed.should eq(1)
    end
    
    it "should set a duration" do
      report = TestReport.from_api_response(response)
      report.duration.should eq(100)
    end
    
    it "should set a skip count" do
      report = TestReport.from_api_response(response)
      report.skipped.should eq(0)
    end
    
  end
  
end

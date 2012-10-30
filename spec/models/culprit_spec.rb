require "spec_helper"

describe Culprit, "-" do
  
  def test_json
    # create json hash
    culprit = {}
    culprit["fullName"] = "Mr Test";
    json = [culprit,culprit]
  end
  
  def test_build
    Build.new()
  end
  
  before do
    Culprit.any_instance.stub(:save) {true}
    Culprit.any_instance.stub(:update_attributes) {true}
  end
  
  describe "When parsing an array of culprits" do
    
    it "should return an array of culprits" do
      test_culprits = Culprit.culprits_from_api_response(test_json,test_build)
      test_culprits.count.should eq(2)
    end
    
    it "should hold a reference to its build" do
      build = test_build
      test_culprits = Culprit.culprits_from_api_response(test_json,build)
      test_culprits.first.builds.should include(build)
    end
    
    it "should save each culprit to the database" do
      test_culprit = Culprit.new
      test_culprit.should_receive(:save).exactly(2).times
      Culprit.stub(:from_api_response) {test_culprit}
      Culprit.culprits_from_api_response(test_json,test_build)
    end
    
  end
  
  describe "When parsing a single culprit" do
    
    def test_culprit
      Culprit.from_api_response(test_json.first)
    end
    
    it 'should create a new culprit if the culprit already exists' do
      Culprit.stub(:find){[]}
      Culprit.should_receive(:new)
      Culprit.from_api_response(test_json.first)
    end
      
    it 'should not create a new culprit if the culprit already exists' do
      Culprit.stub(:find){[0,0,0]}
      Culprit.should_receive(:new).exactly(0).times
      Culprit.from_api_response(test_json.first)
    end
      
    it 'should parse the json and return a culprit' do
      test_culprit.should_not eq(nil)
    end
      
    it 'should set count to zero by default' do
      test_culprit.count.should eq(0)
    end
      
    it 'should set the name' do
      test_culprit.name.should eq("Mr Test")
    end
      
  end

end
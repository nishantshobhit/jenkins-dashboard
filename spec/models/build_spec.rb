require "spec_helper"

describe Build, "-" do
  
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
  
  describe "When parsing" do
    
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
  end

  describe "When creating a Build object from JSON" do
    
    def test_job
      Job.new()
    end
    
    def test_build
      Build.from_api_response(test_json,test_job)
    end
    
    before do
      Build.any_instance.stub(:is_in_database) {false}
    end
    
    it "should assign duration" do
      test_build.duration.should eq(1)
    end
    
    it "should assign name" do
      test_build.name.should eq("Mr Test")
    end
    
    it "should assign success" do
      test_build.success.should eq(true)
    end
    
    it "should assign number" do
      test_build.number.should eq(1)
    end
  end
  
  describe "When parsing culprits" do
    
    def test_culprit
      Culprit.new(:count => 0, :name => "Test")
    end
    
    def test_build
      job = Job.new()
      Build.from_api_response(test_json,job)
    end
    
    before do
      Build.any_instance.stub(:is_in_database) {false}
      Culprit.stub(:update_attributes) {true}
    end
      
    it "should assign culprits when build fails" do
      culprit = test_culprit
      Culprit.stub(:culprits_from_api_response) {[culprit]}
      Build.any_instance.stub(:success) {false}
    
      test_build.culprits.should include(culprit)
    end
  
    it "should not assign culprits when build succeeds" do
      Build.any_instance.stub(:success) {true}
      
      test_build.culprits.should be_empty
    end
    
    describe "and incrementing culprit count" do
      
      it "should increment count when build has culprits" do
        Culprit.stub(:culprits_from_api_response) {[test_culprit]}
        build = Build.new()
        Build.stub(:new){build}
      
        build.should_receive(:increment_culprits_count).exactly(1).times
      
        # parse
        test_build
      end
    
      it "should not increment count when build has no culprits" do
        Culprit.stub(:culprits_from_api_response) {[]}
        build = Build.new()
        Build.stub(:new){build}
      
        build.should_receive(:increment_culprits_count).exactly(0).times
      
        # parse
        test_build
      end
    
      it "should not increment culprit counts for succesful builds" do
        Culprit.stub(:culprits_from_api_response) {[]}
        build = Build.new(:success => true)
        Build.stub(:new){build}
      
        build.should_receive(:increment_culprits_count).exactly(0).times
      
        # parse
        test_build
      end
    
      it "should increment culprit counts for failed builds" do
        Culprit.stub(:culprits_from_api_response) {[test_culprit]}
        build = Build.new(:success => false)
        Build.stub(:new){build}
      
        build.should_receive(:increment_culprits_count).exactly(1).times
      
        # parse
        test_build
      end
      
      it "should add one to the existing count" do
        culprit = test_culprit      
        culprit.count = 1
        
        culprit.should_receive(:update_attributes).with(:count => 2)
        
        Culprit.stub(:culprits_from_api_response) {[culprit]}
        build = Build.new(:success => false)
        Build.stub(:new){build}
        
        # parse
        test_build
      end
      
    end
  
  end
  
end
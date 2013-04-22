require "spec_helper"

describe Developer, "-" do

  before do
    US2::Jenkins.any_instance.stub(:puts)
  end

  def test_json
    # create json hash
    developer = {}
    developer["fullName"] = "Mr Test";
    json = [developer,developer]
  end

  describe "When parsing an array of developers" do

    before do
      Developer.any_instance.stub(:save) {true}
      Developer.any_instance.stub(:update_attributes) {true}
      HTTParty.stub(:get){"response string"}
    end

    it "should return an array of developers" do
      test_developers = Developer.developers_from_api_response(test_json,FactoryGirl.build(:build))
      test_developers.length.should eq(2)
    end

    it "should hold a reference to its build" do
      build = FactoryGirl.build(:build)
      test_developers = Developer.developers_from_api_response(test_json,build)
      test_developers.first.builds.should include(build)
    end

    it "should save each developer to the database" do
      test_developer = FactoryGirl.build(:developer)
      test_developer.should_receive(:save).exactly(2).times
      Developer.stub(:from_api_response) {test_developer}
      Developer.developers_from_api_response(test_json,FactoryGirl.build(:build))
    end

  end

  describe "Before saving" do
    it "should set its broken build count to 0 if it has none" do
      developer = FactoryGirl.build(:developer, broken_build_count: nil)
      developer.save
      developer.broken_build_count.should eq(0)
    end
  end

  describe "When parsing a single developer" do

    def test_developer
      Developer.from_api_response(test_json.first)
    end

    it 'should create a new developer if the developer already exists' do
      Developer.stub(:find){[]}
      Developer.should_receive(:new)
      Developer.from_api_response(test_json.first)
    end

    it 'should not create a new developer if the developer already exists' do
      Developer.stub(:find){[0,0,0]}
      Developer.should_receive(:new).exactly(0).times
      Developer.from_api_response(test_json.first)
    end

    it 'should parse the json and return a developer' do
      test_developer.should_not eq(nil)
    end

    it 'should set broken_build_count to zero by default' do
      developer = test_developer
      developer.save
      developer.broken_build_count.should eq(0)
    end

    it 'should set the name' do
      test_developer.name.should eq("Mr Test")
    end

  end

end

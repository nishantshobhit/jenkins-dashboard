require "spec_helper"

describe Commit, "-" do

  describe "When parsing" do

    def test_json
      json = {}
      json["id"] = "test"
      json["comment"] = "test comment"
      json["author"] = {"fullName" => "test author"}
      json["insertions"] = 1
      json["deletions"] = 1
      json["filesChanged"] = 1
      json["date"] = "2012-11-12 13:27:13 +0000"
      json
    end

    before do
      Commit.stub(:save)
    end

    it "should set a date" do
      commit = Commit.from_api_response(test_json)
      commit.date.day.should eq(12)
      commit.date.month.should eq(11)
      commit.date.year.should eq(2012)
    end

    it "should set the deletions" do
      commit = Commit.from_api_response(test_json)
      commit.deletions.should eq(1)
    end

    it "should set the insertions" do
      commit = Commit.from_api_response(test_json)
      commit.insertions.should eq(1)
    end

    it "should set the files changes" do
      commit = Commit.from_api_response(test_json)
      commit.files_changed.should eq(1)
    end

    it "should set the hash" do
      commit = Commit.from_api_response(test_json)
      commit.sha1hash.should eq("test")
    end

    it "should set the message" do
      commit = Commit.from_api_response(test_json)
      commit.message.should eq("test comment")
    end

    it "should set a developer" do
      developer = FactoryGirl.build(:developer, name:"test author", id: 1)
      Developer.stub(:new){developer}
      Developer.stub(:save)

      commit = Commit.from_api_response(test_json)
      commit.developer_id.should eq(1)
    end

    it "should fetch the developer from the db if it already exists" do
      developer = FactoryGirl.build(:developer, name:"test author", id: 1)

      Developer.stub(:find){[developer]}
      commit = Commit.from_api_response(test_json)

      commit.developer_id.should eq(1)
    end

    it "should create a new developer if it doesn't exist" do
      developer = FactoryGirl.build(:developer, name:"test author", id: 1)
      Developer.stub(:new){developer}
      Developer.stub(:find){[]}
      Developer.should_receive(:new)

      commit = Commit.from_api_response(test_json)
    end

  end

  describe "When checking spelling" do

    it "should check after the commit is saved" do
      commit = FactoryGirl.build(:commit)
      commit.should_receive(:check_spelling)
      commit.save
    end

    it "should assing spelling mistakes if there are any" do
      commit = FactoryGirl.build(:commit, message: 'I canp spell')
      commit.save
      commit.spelling_mistakes.should eq(1)
    end

  end

end

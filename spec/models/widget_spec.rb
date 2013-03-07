require "spec_helper"

describe Widget, "-" do

  it "should convert size strings to integers " do
    @widget = FactoryGirl.build(:widget)
    @widget.size = "fullscreen"
    @widget.size.should eq(0)
  end

  it "should convert layout strings to integers" do
    @widget = FactoryGirl.build(:widget)
    @widget.layout = "text"
    @widget.layout.should eq(0)
  end

  it "should convert data type strings to integers" do
    @widget = FactoryGirl.build(:widget)
    @widget.data_type = "gitstats"
    @widget.data_type.should eq(0)
  end

  it "should handle incorrect data type strings" do
    @widget = FactoryGirl.build(:widget)
    @widget.data_type = "blah"
    @widget.data_type.should eq(nil)
  end

  it "should handle incorrect layout strings" do
    @widget = FactoryGirl.build(:widget)
    @widget.layout = "blah"
    @widget.layout.should eq(nil)
  end

  it "should handle incorrect size strings" do
    @widget = FactoryGirl.build(:widget)
    @widget.size = "blah"
    @widget.size.should eq(nil)
  end

  it "should handle uppercase data type strings" do
    @widget = FactoryGirl.build(:widget)
    @widget.data_type = "GitStaTs"
    @widget.data_type.should eq(0)
  end

  it "should handle uppercase layout strings" do
    @widget = FactoryGirl.build(:widget)
    @widget.layout = "TeXT"
    @widget.layout.should eq(0)
  end

  it "should handle uppercase size strings" do
    @widget = FactoryGirl.build(:widget)
    @widget.size = "FulLScReen"
    @widget.size.should eq(0)
  end

end

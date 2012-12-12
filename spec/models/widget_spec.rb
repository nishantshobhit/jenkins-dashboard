require "spec_helper"

describe Widget, "-" do

  it "should convert size strings to integers " do
    @widget = FactoryGirl.build(:widget)
    @widget.size = "large"
    @widget.size.should eq(2)
  end

  it "should convert layout strings to integers" do
    @widget = FactoryGirl.build(:widget)
    @widget.layout = "bar"
    @widget.layout.should eq(0)
  end

  it "should convert data type strings to integers" do
    @widget = FactoryGirl.build(:widget)
    @widget.data_type = "health"
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
    @widget.data_type = "HeAlTH"
    @widget.data_type.should eq(0)
  end

  it "should handle uppercase layout strings" do
    @widget = FactoryGirl.build(:widget)
    @widget.layout = "bAr"
    @widget.layout.should eq(0)
  end

  it "should handle uppercase size strings" do
    @widget = FactoryGirl.build(:widget)
    @widget.size = "LARGE"
    @widget.size.should eq(2)
  end

end

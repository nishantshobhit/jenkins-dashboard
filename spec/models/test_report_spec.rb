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

  before do
    HTTParty.stub(:get){"response string"}
    US2::Jenkins.any_instance.stub(:puts)
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

  describe "When generating a JSON response" do

    describe "For global data" do
      it "should return a json reponse" do
        builds = []
        TestReport.api_response_for_builds(builds).should_not eq(nil)
      end

      it "should respond with the correct values" do
        build1 = FactoryGirl.build(:build)
        build1.test_report = FactoryGirl.build(:test_report, passed: 1, failed: 2, skipped: 3)

        build2 = FactoryGirl.build(:build)
        build2.test_report = FactoryGirl.build(:test_report, passed: 1, failed: 2, skipped: 3)

        builds = [build1,build2]
        TestReport.api_response_for_builds(builds)[:passed].should eq(2)
        TestReport.api_response_for_builds(builds)[:failed].should eq(4)
        TestReport.api_response_for_builds(builds)[:skipped].should eq(6)
      end

      it "should handle builds with no test_reports" do
        build1 = FactoryGirl.build(:build)
        TestReport.api_response_for_builds([build1])[:passed].should eq(0)
        TestReport.api_response_for_builds([build1])[:skipped].should eq(0)
        TestReport.api_response_for_builds([build1])[:failed].should eq(0)
      end
    end

    describe "For daily data" do
      it "should return a json response" do
        builds = []
        TestReport.api_response_for_daily_builds(builds).should_not eq(nil)
      end

      it "should group the builds by day" do
        Build.any_instance.should_receive(:group_by_day)
        builds = [FactoryGirl.build(:build)]
        TestReport.api_response_for_daily_builds(builds)
      end

      it "should respond with the correct values" do
        # create a build
        build = FactoryGirl.build(:build)
        build.test_report = FactoryGirl.build(:test_report, passed: 1, failed: 2, skipped: 3)

        # return fake group
        Array.any_instance.stub(:group_by) {{"Day" => [build]}}

        # get response from stub
        response = TestReport.api_response_for_daily_builds([build])

        response.first[:passed].should eq(1)
        response.first[:failed].should eq(2)
        response.first[:skipped].should eq(3)
      end
    end

  end

end

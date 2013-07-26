require "spec_helper"

describe US2::Request, "-" do

  before do request
    US2::Jenkins.any_instance.stub(:puts)
  end

  describe "When executing requests" do

    before do
      HTTParty.stub(:get){"response string"}
    end

    def request
      US2::Request.new
    end

    it "should execute a callback on completion" do
      request.async_request("http://google.com") do |response|
        response.should match("response string")
      end
    end

    it "should execute on a new thread" do
      Thread.should_receive(:new)
      request.async_request("http://google.com")
    end
  end

end

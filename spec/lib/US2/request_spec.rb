require "spec_helper"

describe US2::Request, "-" do

  def request
    US2::Request.instance
  end

  describe "When executing requests" do

    before do
      HTTParty.stub(:get){"response string"}
    end

    def request
      US2::Request.new
    end

    it "should send a request to a url" do
      HTTParty.should_receive(:get).with("http://google.com", anything())
      request.async_request("http://google.com")
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

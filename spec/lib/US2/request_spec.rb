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
      HTTParty.should_receive(:get).with("hello world", anything())
      request.async_request("hello world")
    end

    it "should execute a callback on completion" do
      request.async_request("hello world") do |response|
        response.should_eq("response string")
      end
    end

    it "should execute on a new thread" do
      Thread.should_receive(:new)
      request.async_request("hello world")
    end
  end

end

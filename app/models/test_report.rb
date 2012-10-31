class TestReport < ActiveRecord::Base
  belongs_to :build
  attr_accessible :duration, :failed, :passed, :skipped
  
  class << self
    def from_api_response(reponse)
      #set up vars
      duration = api_response["duration"]
      name = api_response["fullDisplayName"]
      number = api_response["number"]
      result = api_response["result"] == "FAILURE" ? false : true;
      url = api_response["url"]
      # create new build
      @build = Build.new(:duration => duration, :name => name, :number => number, :success => result, :url => url)
      
      @build
    end
  end
  
end

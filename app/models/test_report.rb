class TestReport < ActiveRecord::Base
  belongs_to :build
  attr_accessible :duration, :failed, :passed, :skipped
  
  class << self
    def from_api_response(response)
      #set up vars
      failed = response["failCount"]
      passed = response["passCount"]
      skipped = response["skipCount"]
      duration = response["duration"]
      
      # create new build
      unless failed.nil? or passed.nil? or skipped.nil? or duration.nil?
        TestReport.new(:duration => duration, :failed => failed, :passed => passed, :skipped => skipped)
      end
    end
  end
  
end

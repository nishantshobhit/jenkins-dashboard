class Build < ActiveRecord::Base
  attr_accessible :duration, :name, :number, :culprit
  validates_presence_of :name, :number, :duration
  
  belongs_to :job
  
  class << self
    
    def from_api_response(api_response)
      duration = api_response["duration"]
      name = api_response["fullDisplayName"]
      number = api_response["number"]
      
      # check for a culprit
      unless api_response["culprits"].length == 0
        culprit_json = api_response["culprits"].first
        culprit = culprit_json["fullName"]
        @build = Build.new(:duration => duration, :name => name, :number => number, :culprit => culprit)
      else
        # dont write one if there is
        @build = Build.new(:duration => duration, :name => name, :number => number)
      end
      @build
    end
    
  end
  
end

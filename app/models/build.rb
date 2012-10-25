class Build < ActiveRecord::Base
  attr_accessible :duration, :name, :number, :culprit
  validates_presence_of :name, :number, :duration
  
  belongs_to :job
  
  class << self
    
    def from_api_response(api_response)
      duration = api_response["duration"]
      name = api_response["fullDisplayName"]
      number = api_response["number"]
      culprit = api_response["culprits"].first["fullName"]
      @build = Build.new(:duration => duration, :name => name, :number => number, :culprit => culprit)
      @build
    end
    
  end
  
end

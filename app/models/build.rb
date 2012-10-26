class Build < ActiveRecord::Base
  attr_accessible :duration, :name, :number, :culprit, :success
  validates_presence_of :name, :number, :duration
  
  belongs_to :job
  
  class << self
    
    def from_api_response(api_response)
      duration = api_response["duration"]
      name = api_response["fullDisplayName"]
      number = api_response["number"]
      result = api_response["result"]
      # check for a culprit
      unless api_response["culprits"].length == 0
        culprit_json = api_response["culprits"].first
        culprit = culprit_json["fullName"]
        @build = Build.new(:duration => duration, :name => name, :number => number, :culprit => culprit, :success => result)
      else
        # dont write one if there is
        @build = Build.new(:duration => duration, :name => name, :number => number, :success => result)
      end
      @build
    end
    
    def has(build)
      @query = Build.find(:all, :conditions => {:number => build.number, :name => build.name})
      @query.any?
    end
    
  end
  
  def success=(value)
    if value == "FAILURE"
      write_attribute(:success, false)
    else
      write_attribute(:success, true)
    end
  end

end
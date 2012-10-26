class Build < ActiveRecord::Base
  attr_accessible :duration, :name, :number, :culprit, :success
  validates_presence_of :name, :number, :duration
  
  has_and_belongs_to_many :culprits
  belongs_to :job
  
  class << self
    
    def from_api_response(api_response)
      duration = api_response["duration"]
      name = api_response["fullDisplayName"]
      number = api_response["number"]
      result = api_response["result"]
      
      culprits = parse_culprits(api_response["culprits"])
      
      # check for a culprit
      unless culprits.length == 0
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
  
  def parse_culprits(json)
    #loop through culprits, create objects and return array
  end

end
class Job < ActiveRecord::Base
  attr_accessible :name, :status, :url
  has_many :builds
  validates_presence_of :name, :status, :url
  
  @@status_types = [:fixed, :broken, :building, :disabled, :aborted]

  class << self
    
    def from_api_response(api_response)
      @job = Job.new(:name => api_response["name"], :status => api_response["color"], :url => api_response["url"])
      @job
    end
    
  end
  
  def status_name
    @@status_types[self.status]
  end
  
  def status=(value)
    if value.include? "anime"
      value = "building"
    elsif value == "blue"
      value = "fixed"
    elsif value == "red"
      value = "broken"
    elsif value == "grey"
      value = "disabled"
    end
    @status = @@status_types.index(value.to_sym)
    if @status
      write_attribute(:status, @status)
    end
  end
  
end

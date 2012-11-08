class Job < ActiveRecord::Base
  attr_accessible :name, :status, :url
  has_many :builds
  validates_presence_of :name, :status, :url
  validates_uniqueness_of :name, :url

  @@status_types = [:fixed, :broken, :building, :disabled, :aborted]

  class << self

    def from_api_response(api_response)
      @query = Job.find(:all, :conditions => {:url => api_response["url"], :name => api_response["name"]})
      # see if we have the job in the db already and just update it if so
      if @query.length == 0
        @job = Job.new(:name => api_response["name"], :status => api_response["color"], :url => api_response["url"])
      else
        @job = @query.first
        @job.status = api_response["color"];
      end
      @job
    end

  end

  def status_name
    @@status_types[self.status.to_i]
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

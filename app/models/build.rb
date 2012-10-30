class Build < ActiveRecord::Base
  attr_accessible :duration, :name, :number, :success, :url
  validates_presence_of :name, :number, :duration
  after_save :update_culprits
  
  has_and_belongs_to_many :culprits
  belongs_to :job
  
  class << self
    
    def from_api_response(api_response,job)
      #set up vars
      duration = api_response["duration"]
      name = api_response["fullDisplayName"]
      number = api_response["number"]
      result = api_response["result"] == "FAILURE" ? false : true;
      url = api_response["url"]
      # create new build
      @build = Build.new(:duration => duration, :name => name, :number => number, :success => result, :url => url)
      # return nil if we've already saved this build
      return nil if @build.is_in_database;
      # assign job
      @build.job = job
      # assign culprits
      @build.culprits = Culprit.culprits_from_api_response(api_response["culprits"], @build) unless @build.success
      #return build
      @build
    end
    
  end

  def is_in_database
    @query = Build.find(:all, :conditions => {:number => self.number, :name => self.name})
    @query.any?
  end
  
  def update_culprits
    # increment the culprits count
    self.increment_culprits_count unless self.culprits.length == 0 or self.success
  end
  
  def increment_culprits_count
    self.culprits.each do |culprit|
      count = culprit.count + 1
      culprit.update_attributes(:count => count)
    end
  end
  
end
class Build < ActiveRecord::Base
  attr_accessible :duration, :name, :number, :success, :url
  validates_presence_of :name, :number, :duration
  after_save :update_culprits, :get_test_report
  
  has_and_belongs_to_many :culprits
  belongs_to :job
  has_one :test_report
  
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
      return nil if @build.is_in_database
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
  
  def get_test_report
    jenkins = US2::Jenkins.new()
    jenkins.get_test_report(self) do |report|
      puts "Saving report: #{report.id} for build #{self.name}" unless report.nil?
      report.build = self unless report.nil?
      report.save! unless report.nil?
     end
  end
  
  def health_response
    {:created_at => self.created_at, :success => self.success}
  end

end
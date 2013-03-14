class Job < ActiveRecord::Base
  attr_accessible :name, :status, :url
  has_many :builds
  has_many :widgets
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

  def passed_tests
    total = 0
    self.builds.each do |build|
      total += build.test_report.passed if build.test_report
    end
    total
  end

  def build_breaker
    broken_builds = self.builds.where("success = FALSE")
    hash = {}
    broken_builds.each do |build|
      build.commits.each do |commit|
        developer = commit.developer.name
        if hash[developer]
          hash[developer] = hash[developer] + 1
        else
          hash[developer] = 1
        end
      end
    end
    sorted = hash.sort_by {|_key, value| value}
    sorted.last.first
  end

  def failed_tests
    total = 0
    self.builds.each do |build|
      total += build.test_report.failed if build.test_report
    end
    total
  end

  def skipped_tests
    total = 0
    self.builds.each do |build|
      total += build.test_report.skipped if build.test_report
    end
    total
  end

  def insertions
    total = 0
    self.builds.each do |build|
      build.commits.each do |commit|
        total += commit.insertions if commit.insertions
      end
    end
    total
  end

  def deletions
    total = 0
    self.builds.each do |build|
      build.commits.each do |commit|
        total += commit.deletions if commit.deletions
      end
    end
    total
  end

  def failed_builds
    total = self.builds.where("success = FALSE").count
    total
  end

  def successful_builds
    total = self.builds.where("success = TRUE").count
    total
  end

  def total_lines
    self.insertions - self.deletions
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

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

  def latest_build
    self.builds.sort!{|x, y| y["number"] <=> x["number"]}.first
  end

  def passed_tests
    passed = latest_build.test_report.passed if latest_build.test_report
    if !passed
      passed = 0
    end
    passed
  end

  def build_breaker
    broken_builds = self.builds.where("success = FALSE")
    hash = {}
    broken_builds.each do |build|
      build.commits.each do |commit|
        if commit.developer.name != "unknown"
          developer = commit.developer.name
          if hash[developer]
            hash[developer] = hash[developer] + 1
          else
            hash[developer] = 1
          end
        end
      end
    end
    sorted = hash.sort_by {|_key, value| value}
    if sorted.last
      sorted.last.first
    else
     "unknown"
    end
  end

  def most_commits
    hash = {}
    self.developers.each do |developer|
      if developer.name != "unknown"
        commits = self.builds.where(:commits => {:developer_id => developer.id}).joins(:commits).count
        if hash[developer.name]
          hash[developer.name] = hash[developer.name] + commits
        else
          hash[developer.name] = commits
        end
      end
    end
    sorted = hash.sort_by {|_key, value| value}
    sorted.last.first if sorted
  end

  def failed_tests
    latest_build.test_report.failed if latest_build.test_report
    failed = latest_build.test_report.failed if latest_build.test_report
    if !failed
      failed = 0
    end
    failed
  end

  def skipped_tests
    latest_build.test_report.skipped if latest_build.test_report
    skipped = latest_build.test_report.skipped if latest_build.test_report
    if !skipped
      skipped = 0
    end
    skipped
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

  def developers
    devs = []
    self.builds.each do |build|
      build.commits.each do |commit|
        devs << commit.developer
      end
    end
    devs.to_set
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

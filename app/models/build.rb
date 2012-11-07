class Build < ActiveRecord::Base
  attr_accessible :duration, :name, :number, :success, :url, :date
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
      date = api_response["id"]

      # return nil if the build is still building..
      return nil if api_response["building"] == "true" || api_response["building"] == true
      # create new build
      @build = Build.new(:duration => duration, :name => name, :number => number, :success => result, :url => url)

      if date
        @build.date = DateTime.strptime(date,"%Y-%m-%d_%H-%M-%S")
      end

      # return nil if we've already saved this build
      return nil if @build.is_in_database
      # assign job
      @build.job = job
      # assign culprits
      @build.culprits = Culprit.culprits_from_api_response(api_response["culprits"], @build) unless @build.success
      #return build
      @build
    end

    def duration_response_for_builds(builds)
      response = []

      builds = builds.sort_by &:date

      build_groups = builds.group_by(&:group_by_day)

      build_groups.each do |date, build_group|

        job_groups = build_group.group_by(&:job)

        job_groups.each do |job, job_group|

          average = 0

          job_group.each do |build|
            average = average + (build.duration / 1000)
          end

          average = average / job_group.length

          data = {:date => date, job.name => average}

          response.push(data)

        end

      end

      response
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
      report.build = self unless report.nil?
      report.save! unless report.nil?
     end
  end

  def health_response
    {:created_at => self.created_at, :success => self.success}
  end

  def group_by_day
    date.to_date.to_s(:db)
  end


end

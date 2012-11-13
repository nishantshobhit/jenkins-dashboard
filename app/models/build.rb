class Build < ActiveRecord::Base
  attr_accessible :duration, :name, :number, :success, :url, :date
  validates_presence_of :name, :number, :duration, :job_id
  after_save :update_developers, :get_test_report
  validates_uniqueness_of :name, :url

  has_and_belongs_to_many :developers
  has_many :commits
  belongs_to :job
  has_one :test_report

  class << self

    def from_api_response(api_response)
      #set up vars
      duration = api_response["duration"]
      name = api_response["fullDisplayName"]
      number = api_response["number"]
      result = api_response["result"] == "FAILURE" ? false : true;
      url = api_response["url"]
      date = api_response["id"]
      changes = api_response["changeSet"]

      # return nil if the build is still building..
      return nil if api_response["building"] == "true" || api_response["building"] == true
      # create new build
      @build = Build.new(:duration => duration, :name => name, :number => number, :success => result, :url => url)

      if date
        @build.date = DateTime.strptime(date,"%Y-%m-%d_%H-%M-%S")
      end

      # assign developers
      @build.developers = Developer.developers_from_api_response(api_response["culprits"], @build) unless @build.success

      # handle commits
      if changes and changes["items"].length > 0
        items = api_response["changeSet"]["items"]
        items.each do |item|
          if item["id"] #only parse commits from git (which have an id)
            @commit = Commit.from_api_response(item)
            @build.commits.push(@commit)
          end
        end
      end

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

  def update_developers
    # increment the developers count
    self.increment_developers_broken_build_count unless self.developers.length == 0 or self.success
  end

  def increment_developers_broken_build_count
    self.developers.each do |developer|
      count = developer.broken_build_count + 1
      developer.update_attributes(:broken_build_count => count)
    end
  end

  def get_test_report
    jenkins = US2::Jenkins.new()
    jenkins.get_test_report(self) do |report|
      report.build_id = self.id unless report.nil?
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

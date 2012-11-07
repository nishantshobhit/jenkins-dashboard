module US2
  class Jenkins

    def initialize
      @config = YAML::load(File.open("#{Rails.root}/config/jenkins.yml"))[Rails.env]
      @auth = {:username => @config["client_id"], :password => @config["client_key"]}
    end

    @@instance = Jenkins.new

    def self.instance
      return @@instance
    end

    def sync
      jobs.each do |job|
        puts "Fetched the job: #{job.name}" unless job.nil?
        job.save!
        job.get_latest_build
      end
    end

    def populate
      jobs.each do |job|
        puts "Fetched the job: #{job.name}" unless job.nil?
        job.save!
        job.get_all_builds
      end
    end

    def jobs
      url = @config["client_url"] + "/view/WallDisplay/api/json/"
      response = HTTParty.get(url, :basic_auth => @auth)
      jobs = []

      if response["jobs"]
        response["jobs"].each do |job|
          @job = Job.from_api_response(job)
          jobs.push(@job)
        end
      end

      jobs
    end

    def get_latest_build(job, &block)
      build_url = latest_build_url(job)
      response = HTTParty.get("#{build_url}api/json", :basic_auth => @auth)
      @build = Build.from_api_response(response,job)
      puts "Fetched the build: #{@build.name}" unless @build.nil?
      block.call(@build)
    end

    def get_all_builds(job, &block)
      build_urls = build_urls(job)

      builds = []

      build_urls.each do |url|
        response = HTTParty.get("#{url}api/json", :basic_auth => @auth)
        @build = Build.from_api_response(response,job)
        puts "Fetched the build: #{@build.name}" unless @build.nil?
        builds.push(@build)
      end

      block.call(builds)
    end

    def get_test_report(build, &block)
      response = HTTParty.get("#{build.url}testReport/api/json", :basic_auth => @auth)
      if build_response_has_test_report(response)
        @test_report = TestReport.from_api_response(response)
        puts "Test report created for #{build.name}" unless build.nil?
      end
      block.call(@test_report)
    end

    private

    def latest_build_url(job)
      response = HTTParty.get("#{job.url}api/json", :basic_auth => @auth)
      builds = response["builds"]
      if builds
        builds.first["url"]
      end
    end

    def build_urls(job)
      response = HTTParty.get("#{job.url}api/json", :basic_auth => @auth)
      builds = response["builds"]
      urls = []
      if builds
        builds.each do |build|
          urls.push(build["url"])
        end
      end
      urls
    end

    def build_response_has_test_report(response)
      if response.is_a?(Hash)
        response.has_key?("passCount")
      else
        false
      end
    end

  end
end

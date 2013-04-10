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
        job.save

        #get the latest build for the job and save it
        get_latest_build(job) do |build|
          build.save
        end
      end
    end

    def populate
      jobs.each do |job|
        job.save

        # get every build for the job and save it
        get_all_builds(job) do |builds|
          builds.each do |build|
            puts "Fetched: #{build.name} for #{build.job.name}"
            build.save
          end
        end
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
      else
        puts "There was a problem:"
        puts
        puts response
      end

      jobs
    end

    def get_latest_build(job, &block)
      # get the builds url
      build_url = latest_build_url(job)
      # request from jenkins
      response = HTTParty.get("#{build_url}api/json", :basic_auth => @auth)

      if response.code < 400 && response != nil
        # create a new buld object
        @build = Build.from_api_response(response)

        # assign the job
        @build.job_id = job.id unless job.nil? or @build.nil?
        # return it
        block.call(@build)
      end
    end

    def get_all_builds(job, &block)
      # get every build url for the job
      build_urls = build_urls(job)

      builds = []
      # loop through the urls and go get em
      build_urls.each do |url|
        # get the build json from jenkins
        response = HTTParty.get("#{url}api/json", :basic_auth => @auth)

        if response.code < 400
          # create a build object
          @build = Build.from_api_response(response)

          # assign the job
          @build.job_id = job.id unless job.nil? or @build.nil?
          # add it to the builds array
          builds.push(@build) unless @build.nil?
        else
          puts "Error fetching Build #{url}"
        end
      end
      # return the build objects
      block.call(builds)
    end

    def get_test_report(build, &block)
      response = HTTParty.get("#{build.url}testReport/api/json", :basic_auth => @auth)
      if response.code < 400
        if build_response_has_test_report(response) and response.code < 400
          @test_report = TestReport.from_api_response(response)
        end
        block.call(@test_report)
      end
    end

    private

    def latest_build_url(job)
      response = HTTParty.get("#{job.url}api/json", :basic_auth => @auth)
      if response.code < 400
        builds = response["builds"]
        if builds
          builds.first["url"]
        end
      end
    end

    def build_urls(job)
      response = HTTParty.get("#{job.url}api/json", :basic_auth => @auth)
      if response.code < 400
        builds = response["builds"]
        urls = []
        if builds
          builds.each do |build|
            urls.push(build["url"])
          end
        end
        urls
      end
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

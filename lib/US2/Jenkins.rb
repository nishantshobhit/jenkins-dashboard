module US2
  class Jenkins

    def initialize
      @config = YAML::load(File.open("#{Rails.root}/config/jenkins.yml"))[Rails.env]
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
        puts
        puts "Fetching #{job.name}"
        puts "Fetching #{job.name}".length.times.map {"="}.join
        job.save
        # get every build for the job and save it
        get_all_builds(job) do |builds|
          builds.each do |build|
            puts "Fetched: #{build.name}" if build.name
            build.save
          end
        end
      end
    end

    def jobs
      url = @config["client_url"] + "/view/WallDisplay/api/json/"
      jobs = []
      request = US2::Request.new
      thread = request.async_request(url) do |response|
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
        #return the jobs
      end
      thread.join
      ActiveRecord::Base.connection.close
      jobs
    end

    def get_latest_build(job, &block)
      # get the builds url
      build_url = latest_build_url(job)
      # request from jenkins
      request = US2::Request.new
      thread = request.async_request("#{build_url}api/json") do |response|
        if response.code < 400 && response != nil
          # create a new buld object
          @build = Build.from_api_response(response)

          # assign the job
          @build.job_id = job.id unless job.nil? or @build.nil?
          # return it
          block.call(@build)
        end
      end
      thread.join
      ActiveRecord::Base.connection.close
    end

    def get_all_builds(job, &block)
      # get every build url for the job
      build_url = latest_build_url(job)
      # get the number so we can just loop down to 0
      build_number = build_url.split("/").last.to_i
      # array for the builds
      builds = []
      # new request object
      request = US2::Request.new
      # loop through the urls and go get em
      while build_number > 0 do
        # create the request url
        url = "#{job.url}#{build_number}/api/json"
        # user output
        puts "Requesting: #{url}"
        # get the build json from jenkins
        thread = request.async_request(url) do |response|
          if response.code < 400
            # create a build object
            @build = Build.from_api_response(response)
            # assign the job
            @build.job_id = job.id unless job.nil? or @build.nil?
            # add it to the builds array
            builds.push(@build) unless @build.nil?
          else
            puts "Error fetching Build at: url"
          end
        end
        # wait for thread to finish
        thread.join
        ActiveRecord::Base.connection.close
        # increment build number down
        build_number = build_number - 1
      end
      # return the build objects
      block.call(builds) if block
    end

    def get_test_report(build, &block)
      request = US2::Request.new
      thread = request.async_request("#{build.url}testReport/api/json") do |response|
        if response.code < 400
          if build_response_has_test_report(response) and response.code < 400
            @test_report = TestReport.from_api_response(response)
          end
          block.call(@test_report)
        end
      end
      thread.join
      ActiveRecord::Base.connection.close
    end

    private

    def latest_build_url(job)
      request = US2::Request.new
      url = ""
      thread = request.async_request("#{job.url}api/json") do |response|
        if response.code < 400
          builds = response["builds"]
          if builds
            url = builds.first["url"]
          end
        end
      end
      thread.join
      ActiveRecord::Base.connection.close
      url
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

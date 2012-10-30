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
    
    def get_jobs
      url = @config["client_url"] + "/view/WallDisplay/api/json/"
      response = HTTParty.get(url, :basic_auth => @auth)
      if response["jobs"]
        response["jobs"].each do |job|
          @job = Job.from_api_response(job)
          get_latest_build(@job) do |build|
            build.save unless build.nil?
          end
        end
      end
    end
    
    def get_latest_build(job, &block)
      build_url = latest_build_url(job)
      response = HTTParty.get("#{build_url}api/json", :basic_auth => @auth)
      @build = Build.from_api_response(response,job)
      block.call(@build)
    end
    
    def build_response_has_test_report(response)
      if response.is_a?(Hash)
        response.has_key?("passCount")
      else
        false
      end
    end
    
    private
    
    def latest_build_url(job)
      response = HTTParty.get("#{job.url}api/json", :basic_auth => @auth)
      builds = response["builds"]
      if builds
        builds.first["url"]
      end
    end
    
  end
end
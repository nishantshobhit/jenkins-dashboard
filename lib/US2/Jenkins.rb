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
        Job.delete_all
        response["jobs"].each do |job|
          @job = Job.from_api_response(job)
          if @job.save
              get_build(@job) do |build|
                buld.save
              end
          end
        end
      end
    end
    
    def get_build(job, callback)
      build_url = latest_build_url(job)
      response = HTTParty.get("#{build_url}api/json", :basic_auth => @auth)
      @build = Build.from_api_response(response)
      @build.job = job
      callback(@build)
    end
    
    private
    
    def latest_build_url(job)
      response = HTTParty.get("#{job.url}api/json", :basic_auth => @auth)
      builds = response["builds"]
      if builds
        first_build = builds.first
        first_build["url"]
      end
    end
    
  end
end
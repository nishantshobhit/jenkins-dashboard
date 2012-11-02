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
      get_jobs
    end
    
    def get_jobs
      url = @config["client_url"] + "/view/WallDisplay/api/json/"
      response = HTTParty.get(url, :basic_auth => @auth)
      if response["jobs"]
        response["jobs"].each do |job|
          @job = Job.from_api_response(job)
          @job.save!
        end
      end
    end
    
    def get_latest_build(job, &block)
        build_url = latest_build_url(job)
        response = HTTParty.get("#{build_url}api/json", :basic_auth => @auth)
        @build = Build.from_api_response(response,job)
        block.call(@build)
    end
    
    def get_test_report(build, &block)
      response = HTTParty.get("#{build.url}testReport/api/json", :basic_auth => @auth)
      if build_response_has_test_report(response)
        @test_report = TestReport.from_api_response(response)
        puts "Test report created #{@test_report}"
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
    
    def build_response_has_test_report(response)
      if response.is_a?(Hash)
        puts "Has report"
        response.has_key?("passCount")
      else
        puts "No report.."
        false
      end
    end
    
  end
end
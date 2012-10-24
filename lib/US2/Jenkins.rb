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
      @url = @config["client_url"] + "/view/WallDisplay/api/json/"
      response = HTTParty.get(@url, :basic_auth => @auth)
      if response["jobs"]
        Job.delete_all
        response["jobs"].each do |job|
          @job = Job.new(:name => job["name"], :status => job["color"])
          @job.save
        end
      end
    end
    
  end
end
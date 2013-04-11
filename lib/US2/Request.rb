module US2
  class Request

    def initialize
      @config = YAML::load(File.open("#{Rails.root}/config/jenkins.yml"))[Rails.env]
      @auth = {:username => @config["client_id"], :password => @config["client_key"]}
    end

    def async_request(url, &callback)
      Thread.new {
        begin
          response = HTTParty.get(url, :basic_auth => @auth)
          callback.call(response) if callback
        rescue StandardError => e
          puts "Error from HTTParty: #{e.inspect}"
          puts e.backtrace
        end
      }
    end
  end
end

module Api

  class DurationController < BaseController

    def index
      builds ||= Build.find(:all, :conditions => ["duration > 0 AND duration < 1000000 AND success == ?",true])
      respond_with(Build.duration_response_for_builds(builds))
    end

  end

end

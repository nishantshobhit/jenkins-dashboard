module Api

  class DurationController < BaseController

    def index
      response = []
      Job.all.each do |job|
        builds = job.builds
        if builds.length > 0
          response.append({:name => job.name, :duration => Build.average_duration_for_builds(builds)})
        end
      end
      respond_with(response)
    end

  end

end

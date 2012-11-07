module Api

  class HealthController < BaseController

    def index
      @jobs ||= Job.find(:all)

      failed = 0
      built = 0

      @jobs.each do |job|
        job.builds.each do |build|
          built = built +1 unless !build.success
          failed = failed +1 unless build.success
        end
      end

      data = [{:count => built, :key => "built"}, {:count => failed, :key => "failed"}]
      respond_with(data)
    end

    def show
      @job = Job.find_by_id(params[:id])
      @failed_builds = @job.builds.where(:success => false)
      @success_builds = @job.builds.where(:success => true)
      @builds = @job.builds.all(:order => "created_at ASC")

      data = [{:count => @success_builds.length, :key => "built"}, {:count => @failed_builds.length, :key => "failed"}]
      respond_with(data)
    end

  end

end

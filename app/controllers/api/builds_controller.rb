module Api

	class BuildsController < BaseController

		def index
			@job = Job.find_by_id(params[:job_id])
			@builds = @job.builds.all(:order => "created_at ASC")
			respond_with(@builds)
		end

		def show
			@build = Build.find(params[:id])
		  	respond_with(@build)
		end

	end

end

class BuildsController < ApplicationController
	respond_to :html, :json

	def index
		@job = Job.find_by_id(params[:job_id])
		@builds = @job.builds.all(:order => "created_at ASC")
		respond_with(@builds)
	end
	  
	def show
		#@build = Build.find(params[:id])
	  	#respond_with(@build)
	end

	def health
		@job = Job.find_by_id(params[:id])
		@builds = @job.builds.all(:order => "created_at ASC")

		builds_response = []

		@builds.each do |build|
			builds_response.push(build.health_response)
		end

		respond_with(builds_response)
	end
end
class BuildsController < ApplicationController
	respond_to :html, :json

	def index
		@job = Job.find_by_id(params[:job_id])
		@builds = @job.builds
		respond_with(@builds)
	end
	  
	def show
		#@build = Build.find(params[:id])
	  	#respond_with(@build)
	end
end
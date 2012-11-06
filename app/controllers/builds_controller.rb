class BuildsController < ApplicationController
	respond_to :html, :json

	def index
		@job = Job.find_by_id(params[:job_id])
		@builds = @job.builds.all(:order => "created_at ASC")
		respond_with(@builds)
	end

	def show
		@build = Build.find(params[:id])
	  	respond_with(@build)
	end

	def health
		@job = Job.find_by_id(params[:id])
		@failed_builds = @job.builds.where(:success => false)
		@success_builds = @job.builds.where(:success => true)
		@builds = @job.builds.all(:order => "created_at ASC")

		data = [{:count => @success_builds.length, :key => "built"}, {:count => @failed_builds.length, :key => "failed"}]
		respond_with(data)
	end

	def global_durations
		builds = Build.find(:all, :conditions => ["duration > 0 AND duration < 1000000"])
		respond_with(Build.duration_response_for_builds(builds))
	end

end

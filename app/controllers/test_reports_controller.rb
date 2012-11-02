class TestReportsController < ApplicationController
	respond_to :html, :json

  	def show
      @job = Job.find(params[:id])
      @builds = @job.builds

      reports = TestReport.api_response_for_builds(@builds)

      respond_with(reports)
  	end

  	def global_report
  		@builds = Build.find(:all)

      reports = TestReport.api_response_for_builds(@builds)
	  	respond_with(reports)
  	end
end

module Api

  class JobsController < BaseController

    def index
    	@jobs ||= Job.find(:all)
      respond_with(@jobs)
    end

    def show
    	@job = Job.find(params[:id])
      @job_hash = {
        :name => @job.name,
        :id => @job.id,
        :insertions => @job.insertions,
        :deletions => @job.deletions,
        :total_lines => @job.total_lines,
        :passed_tests => @job.passed_tests,
        :failed_tests => @job.failed_tests,
        :skipped_tests => @job.skipped_tests
      }
      respond_with(@job_hash)
    end

  end

end

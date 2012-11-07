module Jobs

  class JobsController < BaseController

    def index
    	@jobs ||= Job.find(:all)
      respond_with(@jobs)
    end

    def show
    	@job = Job.find(params[:id])
      respond_with(@job)
    end

  end

end

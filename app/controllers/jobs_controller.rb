class JobsController < ApplicationController
  before_filter :require_user
  respond_to :html, :json

  def index
  	@jobs = Job.find(:all)
    respond_with(@jobs)
  end
  
  def show
  	@job = Job.find(params[:id])
    respond_with(@job)
  end

  def health
    @jobs = Job.find(:all)

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

end                     
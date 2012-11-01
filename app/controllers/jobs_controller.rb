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
end                     
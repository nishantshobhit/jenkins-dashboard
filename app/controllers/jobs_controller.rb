class JobsController < ApplicationController
  before_filter :require_user
  
  def index
    @jobs = Job.find(:all)
  end
  
  def show
    @job = Job.find(params[:id])
  end
end

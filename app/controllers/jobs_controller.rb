class JobsController < ApplicationController
  before_filter :require_user
  
  def show
    @job = Job.find(params[:id])
  end
end

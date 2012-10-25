class DashboardController < ApplicationController
  
  before_filter :require_user
  
  def index
    @jobs ||= Job.find(:all)
  end
end

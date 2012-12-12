class WidgetsController < ApplicationController

  def new
    @widget = Widget.new(:dashboard_id => params[:dashboard_id])
    @jobs = Job.find(:all)
    @jobs.unshift(Job.new(:name => "All"))
  end

  def show
  end

end

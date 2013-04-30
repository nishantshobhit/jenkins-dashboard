class WidgetsController < ApplicationController

  def new
    @widget = Widget.new(:dashboard_id => params[:dashboard_id])
    @jobs = Job.find(:all)
    @jobs.unshift(Job.new(:name => "All", :id => 0))
  end

  def create
    @widget = Widget.create(params[:widget])
    if @widget.save
      render :json => {}
    else
      render :json => {"error" => "failed to save"}, :status => 500
    end
  end

end

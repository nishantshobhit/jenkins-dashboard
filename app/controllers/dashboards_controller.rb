class DashboardsController < ApplicationController

  def show
    @dashboard = Dashboard.find(params[:id], :include => :widgets)
    @widgets = @dashboard.widgets
  end

  def index
    @dashboards ||= Dashboard.find(:all)
    @dashboard = Dashboard.new
  end

  def create
    @dashboard = Dashboard.create(params[:dashboard])
    if @dashboard.save
      redirect_to root_path
    else
      flash[:error] = "Name can't be blank"
      redirect_to new_dashboard_path
    end
  end

  def destroy
    @dashboard = Dashboard.find(params[:id])
    @dashboard.destroy
    redirect_to root_path
  end

end

class DashboardController < ApplicationController

  def index
    @jobs ||= Job.find(:all)
  end
end

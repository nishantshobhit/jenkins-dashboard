class CulpritsController < ApplicationController
  before_filter :require_user
  
  def index
    
    @culprits = Culprit.find(:all)
    
    render :json => @culprits
    
  end
  
end

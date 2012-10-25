class CulpritsController < ApplicationController
  before_filter :require_user
  
  def index
    
    @culprits = get_culprits
    
    respond_to do |format|
      format.json { render :json=> @culprits.to_json }
    end
    
  end
  
end

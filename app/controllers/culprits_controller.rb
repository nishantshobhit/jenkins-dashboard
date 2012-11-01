class CulpritsController < ApplicationController
  respond_to :html, :json
  
  def index
    @culprits = Culprit.find(:all)
    respond_with(@culprits)
  end
  
end

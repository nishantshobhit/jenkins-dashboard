module Api

  class BaseController < ApplicationController
    respond_to :json

    def current_path
      respond_with(Rails.root)
    end
  end

end

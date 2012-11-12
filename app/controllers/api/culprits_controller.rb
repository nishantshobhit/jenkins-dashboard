module Api

  class DevelopersController < BaseController

    def index
      @developers = Developer.find(:all)
      respond_with(@developers)
    end

  end

end

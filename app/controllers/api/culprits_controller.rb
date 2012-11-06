module Api

  class CulpritsController < BaseController

    def index
      @culprits = Culprit.find(:all)
      respond_with(@culprits)
    end

  end

end

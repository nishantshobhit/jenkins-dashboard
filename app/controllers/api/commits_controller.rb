module Api

  class CommitsController < BaseController

    def index
      @commits = Commit.find(:all)
      respond_with(@commits)
    end

  end

end

class Commit < ActiveRecord::Base
  attr_accessible :build_id, :date, :deletions, :developer_id, :files_changed, :sha1hash, :insertions, :message

  belongs_to :developer
  belongs_to :build

  class << self

    def from_api_response(api_response)

      @commit = Commit.new

      if api_response["date"]
        date = DateTime.strptime(api_response["date"],"%Y-%m-%d %H:%M:%S %z")
        @commit.date = date
      end

      if api_response["comment"]
        @commit.message = api_response["comment"]
      end

      if api_response["deletions"]
        @commit.deletions = api_response["deletions"]
      end

      if api_response["insertions"]
        @commit.insertions = api_response["insertions"]
      end

      if api_response["filesChanged"]
        @commit.files_changed = api_response["filesChanged"]
      end

      if api_response["id"]
        @commit.sha1hash = api_response["id"]
      end

      if api_response["author"]
        name = api_response["author"]["fullName"]
        query = Developer.find(:all, :conditions => {:name => name})

        if query.length == 0
          developer = Developer.new(:name => name)
        else
          developer = query.first
        end

        @commit.developer = developer
      end

      @commit.save

      @commit
    end

  end

end

class Commit < ActiveRecord::Base
  attr_accessible :build_id, :date, :deletions, :developer_id, :files_changed, :sha1hash, :insertions, :message, :developer_id, :spelling_mistakes

  belongs_to :developer
  belongs_to :build
  validates_uniqueness_of :sha1hash
  before_save :check_spelling

  class << self

    def from_api_response(api_response)

      if !Commit.exists?(:sha1hash => api_response["id"])
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
            developer.save
          else
            developer = query.first
          end

          @commit.developer_id = developer.id
        end
        @commit.save
      else
        @commit = Commit.where("sha1hash = #{api_response["id"]}")
      end
      @commit
    end

  end

  private

  def check_spelling
    if self.message
      results = Spellchecker.check(self.message, dictionary='en')

      mistakes = 0

      results.each do |result|
        if result[:correct] == false
          mistakes = mistakes + 1
        end
      end

      self.spelling_mistakes = mistakes
    end
  end

end

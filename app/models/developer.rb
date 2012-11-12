class Developer < ActiveRecord::Base
  attr_accessible :broken_build_count, :name
  has_and_belongs_to_many :builds
  has_many :commits

  class << self

    def developers_from_api_response(json,build)
      developers = []
      json.each do |developer_json|
        # parse developer
        developer = self.from_api_response(developer_json)
        # assign build id
        developer.builds.push(build)
        # save it
        developer.save
        # push to array
        developers.push(developer);
      end
      developers
    end

    def from_api_response(response)
      name = response["fullName"]
      @query = Developer.find(:all, :conditions => {:name => name})
      if @query.length == 0
        @developer = Developer.new(:name => name, :broken_build_count => 0)
      else
        @developer = @query.first
      end
      @developer
    end

  end

end

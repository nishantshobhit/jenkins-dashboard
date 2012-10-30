class Culprit < ActiveRecord::Base
  attr_accessible :count, :name
  has_and_belongs_to_many :builds
  
  class << self
    
    def culprits_from_api_response(json,build)
      culprits = []
      json.each do |culprit_json|
        # parse culprit
        culprit = self.from_api_response(culprit_json)
        # assign build id
        culprit.builds.push(build)
        # save it
        culprit.save
        # push to array
        culprits.push(culprit);
      end
      culprits
    end
    
    def from_api_response(response)
      name = response["fullName"]
      @query = Culprit.find(:all, :conditions => {:name => name})
      if @query.length == 0               
        @culprit = Culprit.new(:name => name, :count => 0)
      else
        @culprit = @query.first
      end
      @culprit
    end
    
  end

end

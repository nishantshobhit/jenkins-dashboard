class TestReportsController < ApplicationController
	respond_to :html, :json
  	def show
  	end

  	def global_report
  		reports = []
  		@builds = Build.find(:all)

  		@grouped = @builds.group_by(&:group_by_day)

  	    @grouped.each do |key, builds|

  	    	passed = 0
  	    	failed = 0
  	    	skipped = 0

  	    	builds.each do |build|
  	    		report = build.test_report
	      		unless report.nil?
	      			passed = passed + report.passed
	      			failed = failed + report.failed
	      			skipped = skipped + report.skipped
	      		end
  	    	end

  	    	data = {:passed => passed, :failed => failed, :skipped => skipped, :day => key}
	      	reports.push(data)
  	    end

	  	respond_with(reports)
  	end
end
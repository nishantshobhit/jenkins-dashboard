class TestReport < ActiveRecord::Base
  belongs_to :build
  attr_accessible :duration, :failed, :passed, :skipped

  class << self
    def from_api_response(response)

      #set up vars
      failed = response["failCount"]
      passed = response["passCount"]
      skipped = response["skipCount"]
      duration = response["duration"]

      # create new build
      unless failed.nil? or passed.nil? or skipped.nil? or duration.nil?
        TestReport.new(:duration => duration, :failed => failed, :passed => passed, :skipped => skipped)
      end
    end

    def api_response_for_builds(builds)

      response = []

      @grouped = builds.group_by(&:group_by_day)

      @grouped.each do |key, builds_group|

        passed = 0
        failed = 0
        skipped = 0

        builds_group.each do |build|
          report = build.test_report
          unless report.nil?
            passed = passed + report.passed
            failed = failed + report.failed
            skipped = skipped + report.skipped
          end
        end

        data = {:passed => passed, :failed => failed, :skipped => skipped, :day => key}
        response.push(data)
      end

      response
    end

  end

end

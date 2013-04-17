class TestReport < ActiveRecord::Base
  belongs_to :build
  attr_accessible :duration, :failed, :passed, :skipped, :build_id

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
      response = {:passed => 0, :skipped => 0, :failed => 0}

      builds.each do |build|
        if !build.test_report.nil?
          response[:passed] = build.test_report.passed + response[:passed]
          response[:skipped] = build.test_report.skipped + response[:skipped]
          response[:failed] = build.test_report.failed + response[:failed]
        end
      end

      response
    end

    def api_response_for_daily_builds(builds)

      response = []

      builds = builds.sort_by &:date

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
        # we dont care about empty reports
        response.push(data) unless passed == 0 and failed == 0 and skipped == 0
      end

      response
    end

  end

end

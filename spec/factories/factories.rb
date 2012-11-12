FactoryGirl.define do

  factory :job do
    name "test"
    status "red"
    url "http://test.com"
  end

  factory :build do
    duration 100
    name "test"
    number 100
    success true
    job_id 1
    url "http://test.com"
    date DateTime.now
  end

  factory :developer do
    name "Test"
    broken_build_count 100
  end

  factory :test_report do
    passed 100
    failed 10
    skipped 20
  end

  factory :commit do
    date DateTime.now
    deletions 1
    files_changed 1
    insertions 1
    sha1hash "hash"
    message "test message"
  end

end

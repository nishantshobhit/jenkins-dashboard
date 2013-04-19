FactoryGirl.define do

  factory :job do
    sequence(:name){|n| "name#{n}" }
    status "red"
    sequence(:url){|n| "https://ci-server.ustwo.co.uk:#{n}/job/Honk_branch_dev/"}
  end

  factory :build do
    duration 100
    name "name#{Random.rand(1000)}"
    number 100
    success true
    job_id 1
    url "http://#{Random.rand(1000)}.com"
    date DateTime.now
    association :job
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
    sequence(:sha1hash){|n| "hash#{n}" }
    message "test message"
  end

  factory :dashboard do
    name 'Example Dashboard'
  end

  factory :widget do
    name 'Example Widget'
  end

end

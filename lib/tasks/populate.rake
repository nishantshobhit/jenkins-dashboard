desc "Populate the database with all jobs, builds and test reports"
task :populate => :environment do
  puts "Populating... (this could take a while)"
  US2::Jenkins.instance.populate
end

require 'bundler'
Bundler::GemHelper.install_tasks

desc "Build the project"
task :default => 'test'

desc "Run tests"
task :test do
  sh "bundle exec rspec"
  sh "bundle exec cucumber"
end

desc 'Run features tagged with @wip'
task 'cucumber:wip' do
  sh "bundle exec cucumber --tags @wip"
end

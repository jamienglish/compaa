require 'bundler'

require 'rake'
require 'rake/testtask'
require 'cucumber/rake/task'

Bundler::GemHelper.install_tasks

Rake::TestTask.new :spec do |t|
  t.pattern = 'spec/**/*_spec.rb'
end

Cucumber::Rake::Task.new :features do |t|
  t.cucumber_opts = 'features --format pretty'
end

task :default => [:spec, :features]

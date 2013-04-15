require 'bundler'

require 'rake'
require 'rake/testtask'
require 'cucumber/rake/task'
require 'jasmine'
load 'jasmine/tasks/jasmine.rake'

Bundler::GemHelper.install_tasks

Rake::TestTask.new :spec do |t|
  t.libs   << 'spec'
  t.pattern = 'spec/*_spec.rb'
end

Cucumber::Rake::Task.new :features do |t|
  t.cucumber_opts = 'features --format pretty'
end

task :default => [:spec, :features]

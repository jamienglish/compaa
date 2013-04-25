require 'bundler'

require 'rake'
require 'rake/testtask'
require 'cucumber/rake/task'
require 'jasmine'
load 'jasmine/tasks/jasmine.rake'

Bundler::GemHelper.install_tasks

Rake::TestTask.new :units do |t|
  t.libs   << 'spec'
  t.pattern = 'spec/*_spec.rb'
end

Rake::TestTask.new :integration do |t|
  t.libs   << 'spec'
  t.pattern = 'spec/integration/*_spec.rb'
end

task :spec => [:units, :integration]

Cucumber::Rake::Task.new :features do |t|
  t.cucumber_opts = 'features --format pretty'
end

task :default => [:spec, :features]

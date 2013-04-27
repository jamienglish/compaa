require 'bundler'

require 'rake'
require 'rake/testtask'
require 'cucumber/rake/task'
require 'jasmine'
require 'jasmine-headless-webkit'
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

Jasmine::Headless::Task.new('jasmine:headless') do |t|
  t.colors = true
  t.keep_on_error = true
  #t.jasmine_config = 'this/is/the/path.yml'
end

task :spec => [:units, 'jasmine:headless', :integration]

Cucumber::Rake::Task.new :features do |t|
  t.cucumber_opts = 'features --format pretty'
end

task :default => [:spec, :features]

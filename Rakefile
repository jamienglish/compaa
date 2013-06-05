require 'bundler'

require 'rake'
require 'rake/testtask'
require 'jasmine'
load 'jasmine/tasks/jasmine.rake'

Bundler::GemHelper.install_tasks

task :start_mock do
  require_relative 'mock_app'
end

namespace :spec do
  Rake::TestTask.new :units do |t|
    t.libs   << 'spec'
    t.pattern = 'spec/*_spec.rb'
  end

  Rake::TestTask.new :integration do |t|
    t.libs   << 'spec'
    t.pattern = 'spec/integration/*_spec.rb'
  end

  task :js => :start_mock
end

task 'jasmine:require' => :start_mock

task :spec => ['spec:units', 'jasmine:ci', 'spec:integration']

task :default => :spec

task :demo do
  require 'compaa'

  FileUtils.cp_r('fixtures/homemove/artifacts', 'tmp/homemove/')

  Dir.chdir('tmp/homemove') do
    Rack::Server.start(:app => Compaa::RackApp.new, :Port => 3000)
  end

  FileUtils.rm_rf('tmp/homemove/artifacts')
end

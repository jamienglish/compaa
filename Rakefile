require 'bundler'

require 'rake'
require 'rake/testtask'
require 'jasmine'
require 'jasmine-headless-webkit'
load 'jasmine/tasks/jasmine.rake'

Bundler::GemHelper.install_tasks

namespace :spec do
  Rake::TestTask.new :units do |t|
    t.libs   << 'spec'
    t.pattern = 'spec/*_spec.rb'
  end

  Rake::TestTask.new :integration do |t|
    t.libs   << 'spec'
    t.pattern = 'spec/integration/*_spec.rb'
  end

  Jasmine::Headless::Task.new('js') do |t|
    t.colors = true
    t.keep_on_error = true
  end
end

task :spec => ['spec:units', 'spec:js', 'spec:integration']

task :default => [:spec]

task :demo do
  require 'compaa'

  FileUtils.cp_r('fixtures/homemove/artifacts', 'tmp/homemove/')

  Dir.chdir('tmp/homemove') do
    Rack::Server.start(:app => Compaa::RackApp.new, :Port => 3000)
  end

  FileUtils.rm_rf('tmp/homemove/artifacts')
end

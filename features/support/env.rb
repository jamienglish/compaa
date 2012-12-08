require 'aruba/cucumber'
require 'methadone/cucumber'
require 'wrong'
require 'fileutils'

include Wrong

bin_dir     = File.expand_path File.dirname(__FILE__), '../../bin'
ENV['PATH'] = bin_dir + File::PATH_SEPARATOR + ENV['PATH']
LIB_DIR     = File.expand_path File.dirname(__FILE__), '../../lib'

Before do
  # Using "announce" causes massive warnings on 1.9.2
  @puts = true
  @original_rubylib = ENV['RUBYLIB']
  ENV['RUBYLIB']    = LIB_DIR + File::PATH_SEPARATOR + ENV['RUBYLIB'].to_s
end

After do
  ENV['RUBYLIB'] = @original_rubylib
end

RSpec::Matchers.define :be_the_same_file_as do |expected|
  match do |actual|
    FileUtils.cmp actual, expected
  end
end

RSpec::Matchers.define :exist do
  match do |path|
    File.exists? path 
  end
end

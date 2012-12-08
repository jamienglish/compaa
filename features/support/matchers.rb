require 'fileutils'

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

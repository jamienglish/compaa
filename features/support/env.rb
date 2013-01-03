require 'aruba/cucumber'
require 'methadone/cucumber'
require 'wrong'

include Wrong

bin_dir     = File.expand_path File.dirname(__FILE__), '../../bin'
ENV['PATH'] = bin_dir + File::PATH_SEPARATOR + ENV['PATH']
LIB_DIR     = File.expand_path File.dirname(__FILE__), '../../lib'

Before do
  # Using "announce" causes massive warnings on 1.9.2
  @puts = true
  @original_rubylib = ENV['RUBYLIB']
  ENV['RUBYLIB']    = LIB_DIR + File::PATH_SEPARATOR + ENV['RUBYLIB'].to_s
  @aruba_timeout_seconds = RUBY_PLATFORM == 'java' ? 20 : 5
end

Aruba.configure do |config|
  config.before_cmd do |cmd|
    set_env('JRUBY_OPTS', "-X-C #{ENV['JRUBY_OPTS']}") # disable JIT since these processes are so short lived
  end
end if RUBY_PLATFORM == 'java'

After do
  ENV['RUBYLIB'] = @original_rubylib
end

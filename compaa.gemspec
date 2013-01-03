lib = File.expand_path 'lib', File.dirname(__FILE__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include? lib
require 'compaa/version'

Gem::Specification.new do |gem|
  gem.name          = 'compaa'
  gem.version       = Compaa::VERSION
  gem.authors       = ['BSkyB Helpcentre']
  gem.email         = ['skyhelpcentre@gmail.com']
  gem.summary       = <<-SUMMARY
    Command line tool to compare screenshots outputted from our
    screenshot_comparison gem
  SUMMARY
  gem.homepage      = 'https://github.com/bskyb-commerce-helpcentre/compaa'

  gem.files         = `git ls-files`.split $/
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename f }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  %w[rake aruba simplecov wrong minitest guard-minitest guard-cucumber rack-test].each do |lib|
    gem.add_development_dependency lib
  end

  gem.add_development_dependency 'rb-inotify' if RUBY_PLATFORM =~ /linux/

  if RUBY_PLATFORM =~ /darwin/
    gem.add_development_dependency 'rb-fsevent'
    gem.add_development_dependency 'terminal-notifier-guard'
  end

  gem.add_dependency 'methadone', '~> 1.2.2'
  gem.add_dependency 'haml'
  gem.add_dependency 'watir-webdriver'
  gem.add_dependency 'rack'
end

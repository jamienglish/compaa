$:.push File.expand_path('../lib', __FILE__)
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

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'simplecov'
  gem.add_development_dependency 'minitest'
  gem.add_development_dependency 'rack-test'
  gem.add_development_dependency 'capybara'
  gem.add_development_dependency 'jasmine'
  gem.add_development_dependency 'jasmine-headless-webkit'
  gem.add_development_dependency 'sinatra'
  gem.add_development_dependency 'rack-cors'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'pry-debugger'

  gem.add_dependency 'haml'
  gem.add_dependency 'rack'
  gem.add_dependency 'launchy'
  gem.add_dependency 'coffee-script'
end

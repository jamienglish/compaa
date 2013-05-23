require 'sinatra/base'
require 'json'
require 'rack/cors'

class MockCompaa < Sinatra::Base
  set :port, 4567
  disable :logging

  use Rack::Cors do
    allow do
      origins '*'
      resource '/*', :headers => :any, :methods => [:get, :post]
    end
  end

  get '/artifacts.json' do
    content_type 'application/json'
    {
      artifacts: %w(
        artifacts/reference_screenshots/one.png
        artifacts/reference_screenshots/two.png
        artifacts/reference_screenshots/three.png
        artifacts/reference_screenshots/four.png
      )
    }.to_json
  end
end

Thread.new do
  MockCompaa.run!
end

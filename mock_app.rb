require 'sinatra'
require 'json'
require 'rack/cors'

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

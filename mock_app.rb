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
    difference_images: [
      'artifacts/differences_in_screenshots_this_run/one.png_difference.gif',
      'artifacts/differences_in_screenshots_this_run/two.png_difference.gif',
      'artifacts/differences_in_screenshots_this_run/three.png_difference.gif',
    ]
  }.to_json
end

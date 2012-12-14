require 'sinatra'

module Compaa
  class Screenshots < Sinatra::Base
    get '/' do
      haml :index
    end
  end
end

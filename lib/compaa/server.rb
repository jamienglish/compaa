require 'rack'
require 'haml'
require 'webrick'

module Compaa
  class Server
    attr_writer :root_directory, :port

    DEFAULT_PORT = 7788
    DEFAULT_ROOT = Dir.pwd

    def start
      Thread.new do
        Rack::Handler::WEBrick.run rack_app, :Port => port, :Logger => NullObject.new, :AccessLog => [nil, nil]
      end
    end

    def stop
      Rack::Handler::WEBrick.shutdown
    end

    def port
      @port || DEFAULT_PORT
    end

    private

    def rack_app
      _template = template
      root = @root_directory || DEFAULT_ROOT

      Rack::Builder.new do
        use Rack::Static, :urls => ['/artifacts'], :root => root

        run lambda { |env|
          locals = { :filepath => Rack::Request.new(env).params['filepath'] }
          body   = Haml::Engine.new(_template).render Object.new, locals

          [ 200, { 'Content-Type' => 'text/html' }, Array(body) ]
        }
      end
    end

    def template
      File.read File.expand_path 'template.haml', File.dirname(__FILE__)
    end
  end
end

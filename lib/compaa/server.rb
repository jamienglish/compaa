require 'rack'
require 'haml'
require 'thin'

module Compaa
  class Server
    attr_writer :root_directory, :port

    Thin::Logging.silent = true
    DEFAULT_PORT = 7788
    DEFAULT_ROOT = Dir.pwd

    def start
      Thread.new { server.start }
    end

    def stop
      server.stop
    end

    private

    def root_directory
      @root_directory || DEFAULT_ROOT
    end

    def port
      @port || DEFAULT_PORT
    end

    def server
      @server ||= Thin::Server.new rack_app, port
    end

    def rack_app
      t    = template
      root = root_directory
      Rack::Builder.new do
        use Rack::Static, urls: ['/artifacts'], root: root

        run ->(env) {
          locals = { filepath: Rack::Request.new(env).params['filepath'] }
          body   = Haml::Engine.new(t).render Object.new, locals

          [ 200, { 'Content-Type' => 'text/html' }, body ]
        }
      end
    end

    def template
      File.read File.expand_path 'template.haml', File.dirname(__FILE__)
    end
  end
end

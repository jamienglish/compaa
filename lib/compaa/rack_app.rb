require 'rack'
require 'haml'

module Compaa
  class RackApp
    attr_writer :root_directory

    DEFAULT_ROOT = Dir.pwd

    def app
      template = File.read File.expand_path 'template.haml', File.dirname(__FILE__)
      root     = @root_directory or DEFAULT_ROOT

      Rack::Builder.new do
        use Rack::Static, :urls => ['/artifacts'], :root => root

        run lambda { |env|
          request = Rack::Request.new env

          if request.path == '/' and request.params.has_key? 'filepath'
            locals = { :filepath => request.params['filepath'] }
            body   = Haml::Engine.new(template).render Object.new, locals

            [ 200, { 'Content-Type' => 'text/html' }, [body] ]
          else
            [ 404, {}, ['Not found'] ]
          end
        }
      end
    end
  end
end

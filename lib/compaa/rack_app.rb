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
          elsif request.path == '/script.js'
            js = File.read File.expand_path('script.js', File.dirname(__FILE__))

            [ 200, { 'Content-Type' => 'application/javascript' }, [js] ]
          elsif request.path == '/screenshots' and request.request_method == 'POST' and request.params.has_key? 'filepath'
            generated_image = GeneratedImage.new File.join(root, request.params['filepath'])
            generated_image.create_reference_image
            generated_image.delete_difference_image

            [ 200, { 'Content-Type' => 'text/plain' }, ['Success'] ]
          else
            [ 404, {}, ['Not found'] ]
          end
        }
      end
    end
  end
end

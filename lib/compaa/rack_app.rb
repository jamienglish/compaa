require 'rack'
require 'haml'

module Compaa
  class RackApp
    class << self
      alias :new! :new
    end

    def self.new
      me = self
      Rack::Builder.new do
        use Rack::Static, :urls => ['/artifacts'], :root => Dir.pwd
        run(me.new!)
      end
    end

    def call(env)
      request = Request.new(Rack::Request.new(env))
      request.response
    end

    class Request
      def initialize(request)
        @request = request
      end

      def response
        case @request.request_method
        when 'GET'  then get
        when 'POST' then post
        else        four_oh_four
        end
      end

      def get
        case @request.path
        when '/'          then index
        when '/script.js' then script
        else              four_oh_four
        end
      end

      def post
        if @request.path == '/screenshots'
          screenshots
        else
          four_oh_four
        end
      end

      def index
        return four_oh_four unless @request.params.has_key?('filepath')

        template = File.read File.expand_path 'template.haml', File.dirname(__FILE__)
        locals = { :filepath => @request.params['filepath'] }
        body   = Haml::Engine.new(template).render Object.new, locals

        [ 200, { 'Content-Type' => 'text/html' }, [body] ]
      end

      def screenshots
        if @request.params.has_key?('filepath')
          generated_image = GeneratedImage.new File.join(Dir.pwd, @request.params['filepath'])
          generated_image.create_reference_image
          generated_image.delete_difference_image

          [ 200, { 'Content-Type' => 'text/plain' }, ['Success'] ]
        else
          four_oh_four
        end
      end

      def script
        js = File.read(File.expand_path('script.js', File.dirname(__FILE__)))

        [ 200, { 'Content-Type' => 'application/javascript' }, [js] ]
      end

      def four_oh_four
        [ 404, {}, ['Not found'] ]
      end
    end
  end
end

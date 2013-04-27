require 'rack'
require 'haml'
require 'json'

module Compaa
  class RackApp
    class << self
      alias :new! :new
    end

    def self.new
      me = self
      Rack::Builder.new do
        use Rack::Static, :urls => ['/artifacts/'], :root => Dir.pwd
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
        when '/'                   then index
        when '/underscore.js'      then underscore
        when '/jquery-2.0.0.js'    then jquery
        when '/context_blender.js' then context_blender
        when '/compaa.js'          then script
        when '/artifacts.json'     then artifacts_json
        else                            four_oh_four
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
        template = File.read File.expand_path '../assets/index.haml', File.dirname(__FILE__)
        body = Haml::Engine.new(template).render

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
        js = File.read(File.expand_path('../assets/compaa.js', File.dirname(__FILE__)))

        [ 200, { 'Content-Type' => 'application/javascript' }, [js] ]
      end

      def context_blender
        js = File.read(File.expand_path('../assets/context_blender.js', File.dirname(__FILE__)))

        [ 200, { 'Content-Type' => 'application/javascript' }, [js] ]
      end

      def jquery
        js = File.read(File.expand_path('../assets/jquery-2.0.0.js', File.dirname(__FILE__)))

        [ 200, { 'Content-Type' => 'application/javascript' }, [js] ]
      end

      def underscore
        js = File.read(File.expand_path('../assets/underscore.js', File.dirname(__FILE__)))

        [ 200, { 'Content-Type' => 'application/javascript' }, [js] ]
      end

      def artifacts_json
        json = { difference_images: DifferenceImage.all.map(&:path) }.to_json

        [ 200, { 'Content-Type' => 'application/json' }, [json] ]
      end

      def four_oh_four
        [ 404, {}, ['Not found'] ]
      end
    end
  end
end

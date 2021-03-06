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
        use Rack::Static, :urls => ['/assets'], :root => File.expand_path('..', File.dirname(__FILE__))
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
          path = File.join(Dir.pwd, @request.params['filepath'])
          generated_image = GeneratedImage.new(path)

          generated_image.create_reference_image
          generated_image.delete

          [ 200, { 'Content-Type' => 'text/plain' }, ['Success'] ]
        else
          four_oh_four
        end
      end

      def artifacts_json
        json = { artifacts: GeneratedImage.all }.to_json

        [ 200, { 'Content-Type' => 'application/json' }, [json] ]
      end

      def four_oh_four
        [ 404, { 'Content-Type' => 'text/plain' }, ['Not found'] ]
      end
    end
  end
end

require 'rack'
require 'haml'

module Compaa
  class RackApp
    attr_writer :root_directory

    DEFAULT_ROOT = Dir.pwd

    class << self
      alias :new! :new
    end

    def self.new(root = DEFAULT_ROOT)
      me = self
      Rack::Builder.new do
        use Rack::Static, :urls => ['/artifacts'], :root => root
        run(me.new!(root))
      end
    end

    def initialize(root)
      @root_directory = root
    end

    def call(env)
      template = File.read File.expand_path 'template.haml', File.dirname(__FILE__)
      request = Rack::Request.new(env)

      case request.path
      when '/'
        if request.params.has_key?('filepath')
          locals = { :filepath => request.params['filepath'] }
          body   = Haml::Engine.new(template).render Object.new, locals

          [ 200, { 'Content-Type' => 'text/html' }, [body] ]
        else
          four_oh_four
        end
      when '/script.js'
        js = File.read(File.expand_path('script.js', File.dirname(__FILE__)))

        [ 200, { 'Content-Type' => 'application/javascript' }, [js] ]
      when '/screenshots'
        if request.request_method == 'POST' && request.params.has_key?('filepath')
          generated_image = GeneratedImage.new File.join(@root_directory, request.params['filepath'])
          generated_image.create_reference_image
          generated_image.delete_difference_image

          [ 200, { 'Content-Type' => 'text/plain' }, ['Success'] ]
        else
          four_oh_four
        end
      else
        four_oh_four
      end
    end

    private

    def four_oh_four
      [ 404, {}, ['Not found'] ]
    end
  end
end

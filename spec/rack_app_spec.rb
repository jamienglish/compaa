require 'spec_helper'
require 'rack/test'
require 'json'

module Compaa
  describe RackApp do
    include Rack::Test::Methods

    before do
      @tmp_dir = File.expand_path('tmp', File.dirname(__FILE__))
      FileUtils.mkdir_p(@tmp_dir)
    end

    after do
      FileUtils.rm_rf(@tmp_dir)
    end

    def app
      RackApp.new
    end

    def touch_file path
      FileUtils.mkdir_p(File.dirname(File.join(@tmp_dir, path)))
      FileUtils.touch(File.join(@tmp_dir, path))
    end

    describe "GETs" do
      describe '/' do
        it "requires the filepath param" do
          get '/'
          assert_equal 200, last_response.status
        end
      end

      describe '/assets/compaa.js' do
        it "returns our javascript" do
          get '/assets/compaa.js'
          assert last_response.ok?
          assert_equal 'application/javascript', last_response.headers['Content-Type']
        end
      end

      describe '/artifacts' do
        it "serves artifacts JSON" do
          difference_images = [
            DifferenceImage.new('artifacts/differences_in_screenshots_this_run/one.png_difference.gif'),
            DifferenceImage.new('artifacts/differences_in_screenshots_this_run/two.png_difference.gif'),
            DifferenceImage.new('artifacts/differences_in_screenshots_this_run/three.png_difference.gif'),
          ]

          first_generated = GeneratedImage.new('artifacts/screenshots_generated_this_run/four.png')
          def first_generated.has_reference_image?; false; end

          second_generated = GeneratedImage.new('artifacts/screenshots_generated_this_run/five.png')
          def second_generated.has_reference_image?; true; end

          expected_json = {
            artifacts: %w(
              artifacts/reference_screenshots/one.png
              artifacts/reference_screenshots/two.png
              artifacts/reference_screenshots/three.png
              artifacts/reference_screenshots/four.png
            )
          }.to_json

          DifferenceImage.stub(:all, difference_images) do
            GeneratedImage.stub(:all, [first_generated, second_generated]) do
              get '/artifacts.json'
              assert_equal 'application/json', last_response.content_type
              assert_equal expected_json, last_response.body
            end
          end
        end

        it "serves static files" do
          Dir.stub(:pwd, @tmp_dir) do
            touch_file 'artifacts/file.png'

            get '/artifacts/file.png'

            assert last_response.ok?
            assert_equal 'image/png', last_response.headers['Content-Type']
          end
        end
      end

      describe '/non-existent-url' do
        it "returns a 404" do
          get '/non-existent-url'
          assert last_response.not_found?
        end
      end
    end

    describe 'POSTs' do
      describe '/screenshots' do
        it "expects a filepath query" do
          post '/screenshots'
          assert_equal 404, last_response.status
        end

        it "copies the supplied image path to its reference image" do
          Dir.stub(:pwd, @tmp_dir) do
            touch_file 'artifacts/screenshots_generated_this_run/file.png'
            touch_file 'artifacts/differences_in_screenshots_this_run/file.png_difference.gif'

            refute File.exists? "#{@tmp_dir}/artifacts/reference_screenshots/file.png"
            post '/screenshots', :filepath => 'artifacts/screenshots_generated_this_run/file.png'
            assert File.exists? "#{@tmp_dir}/artifacts/reference_screenshots/file.png"
          end
        end
      end

      describe '/non-existent-url' do
        it "returns a 404" do
          post '/non-existent-url'
          assert last_response.not_found?
        end
      end
    end

    describe "other methods" do
      it 'returns a 404' do
        delete '/'
        assert last_response.not_found?

        put '/'
        assert last_response.not_found?

        options '/'
        assert last_response.not_found?
      end
    end
  end
end

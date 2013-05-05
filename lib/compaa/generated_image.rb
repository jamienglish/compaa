require 'fileutils'

module Compaa
  class GeneratedImage < Struct.new(:path)
    attr_writer :file_manager

    def self.all
      Dir.glob(File.join %w[artifacts screenshots_generated_this_run ** *.png]).map { |path|
        new path
      }
    end

    def create_reference_image
      copy_and_create_directory reference_path
    end

    def has_reference_image?
      File.exists? reference_path
    end

    def reference_path
      path.gsub 'screenshots_generated_this_run', 'reference_screenshots'
    end

    def delete_difference_image
      difference_image_path = path.gsub 'screenshots_generated_this_run', 'differences_in_screenshots_this_run'
      difference_image_path << '_difference.gif'
      file_manager.rm difference_image_path, force: true
    end

    def delete
      file_manager.rm path
    end

    private

    def copy_and_create_directory dest
      file_manager.mkdir_p File.dirname dest
      file_manager.cp path, dest
    end

    def file_manager
      @file_manager ||= FileUtils
    end
  end
end

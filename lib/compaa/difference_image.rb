require 'fileutils'

module Compaa
  class DifferenceImage < Struct.new(:path)
    attr_writer :file_manager

    def create_reference_image
      file_manager.mkdir_p File.dirname reference_path
      file_manager.cp generated_path, reference_path
      file_manager.rm path
    end

    def reference_path
      path.gsub(
        'differences_in_screenshots_this_run', 'reference_screenshots'
      ).gsub('_difference.gif', '')
    end

    def generated_path
      path.gsub(
        'differences_in_screenshots_this_run', 'screenshots_generated_this_run'
      ).gsub('_difference.gif', '')
    end

    private

    def file_manager
      @file_manager ||= FileUtils
    end
  end
end

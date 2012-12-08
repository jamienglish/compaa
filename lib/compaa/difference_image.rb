require 'fileutils'

module Compaa
	class DifferenceImage < Struct.new(:path)
		attr_writer :file_manager

		def create_reference_image
      reference_path = path.gsub(
        'differences_in_screenshots_this_run', 'reference_screenshots'
      ).gsub('_difference.gif', '')
      generated_path = path.gsub(
        'differences_in_screenshots_this_run', 'screenshots_generated_this_run'
      ).gsub('_difference.gif', '')

      file_manager.mkdir_p File.dirname reference_path
      file_manager.cp generated_path, reference_path
      file_manager.rm path
		end

		private

		def file_manager
			@file_manager ||= FileUtils
		end
	end
end

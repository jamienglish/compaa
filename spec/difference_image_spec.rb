require 'spec_helper'

describe Compaa::DifferenceImage do
  attr_reader :path, :subject

  before do
    @path    = File.join %w[artifacts differences_in_screenshots_this_run dir file.png_difference.gif]
    @subject = Compaa::DifferenceImage.new @path
  end

  describe :all do
    it "returns an array of all difference images in the artifacts directory" do
      file_list = [
        File.join(%w[artifacts differences_in_screenshots_this_run file.png_difference.gif]),
        File.join(%w[artifacts differences_in_screenshots_this_run dir file.png_difference.gif]),
        File.join(%w[artifacts differences_in_screenshots_this_run dir file.png_difference_2.gif]),
        File.join(%w[artifacts differences_in_screenshots_this_run dir sub_dir file.png_difference.gif])
      ]

      Dir.stub :glob, file_list do
        Compaa::DifferenceImage.all.map(&:path).must_equal file_list
      end
    end
  end

  it "creates a reference image" do
    mock_file_manager = MiniTest::Mock.new
    subject.file_manager = mock_file_manager

    mock_file_manager.expect :mkdir_p, true, [File.join(%w{artifacts reference_screenshots dir})]

    mock_file_manager.expect :cp, true,
      [ File.join(%w[artifacts screenshots_generated_this_run dir file.png]),
        File.join(%w[artifacts reference_screenshots          dir file.png]) ]

    mock_file_manager.expect :rm, true, [path]

    subject.create_reference_image

    mock_file_manager.verify
  end

  it "provides its corresponding reference image path" do
    reference_path =
      File.join %w[artifacts reference_screenshots dir file.png]

    subject.reference_path.must_equal reference_path
  end

  it "provides its corresponding generated image path" do
    generated_path =
      File.join %w[artifacts screenshots_generated_this_run dir file.png]

    subject.generated_path.must_equal generated_path
  end
end

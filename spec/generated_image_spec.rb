require 'spec_helper'

describe Compaa::GeneratedImage do
  attr_reader :mock_file_manager, :path, :ref_image, :subject

  before do
    @mock_file_manager = MiniTest::Mock.new
    @path      = File.join %w[artifacts screenshots_generated_this_run dir file.png]
    @ref_image = File.join %w[artifacts reference_screenshots dir file.png]
    @subject   = Compaa::GeneratedImage.new @path
  end

  describe :all do
    it "returns an array of all difference images in the artifacts directory" do
      file_list = [
        File.join(%w[artifacts screenshots_generated_this_run dir file.png]),
        File.join(%w[artifacts screenshots_generated_this_run dir new_file.png])
      ]

      Dir.stub :glob, file_list do
        Compaa::GeneratedImage.all.map(&:path).must_equal file_list
      end
    end
  end

  describe :has_reference_image? do
    it "is true when a corresponding reference image exists" do
      subject.file_manager = mock_file_manager

      File.stub :exists?, true do
        assert subject.has_reference_image?
      end

      mock_file_manager.verify
    end

    it "is false when a corresponding reference image does not exist" do
      subject.file_manager = mock_file_manager

      File.stub :exists?, false do
        refute subject.has_reference_image?
      end

      mock_file_manager.verify
    end
  end

  it "creates a reference image" do
    subject.file_manager = mock_file_manager

    mock_file_manager.expect :mkdir_p, true, [File.join(%w{artifacts reference_screenshots dir})]

    mock_file_manager.expect :cp, true,
      [ File.join(%w[artifacts screenshots_generated_this_run dir file.png]),
        File.join(%w[artifacts reference_screenshots          dir file.png]) ]

    subject.create_reference_image

    mock_file_manager.verify
  end

  it "provides its corresponding reference image path" do
    reference_path =
      File.join %w[artifacts reference_screenshots dir file.png]

    subject.reference_path.must_equal reference_path
  end

  it "deletes its corresponding difference image" do
    subject.file_manager = mock_file_manager
    difference_path =
      File.join %w[artifacts differences_in_screenshots_this_run dir file.png_difference.gif]

    mock_file_manager.expect :rm, true, [difference_path]

    subject.delete_difference_image

    mock_file_manager.verify
  end
end

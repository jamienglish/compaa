module FileHelpers
  def sample_reference_image
    fixture_image('sample_reference.png').read
  end

  def sample_generated_image
    fixture_image('sample_generated.png').read
  end

  def sample_difference_image
    fixture_image('sample_generated.png_difference.gif').read
  end

  def fixture_image file_name
    File.new File.join(fixture_image_path, file_name)
  end

  def fixture_image_path
    File.expand_path "../../fixtures", File.dirname(__FILE__)
  end
end

World FileHelpers

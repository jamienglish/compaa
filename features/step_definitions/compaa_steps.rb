Given /^a sample reference screenshot$/ do
  write_file 'artifacts/reference_screenshots/dir/image.png',
    sample_reference_image
end

Given /^a sample generated screenshot$/ do
  write_file 'artifacts/screenshots_generated_this_run/dir/image.png',
    sample_generated_image
end

Given /^a sample difference screenshot$/ do
  write_file 'artifacts/differences_in_screenshots_this_run/dir/image.png_difference.gif',
    sample_difference_image
end

When /^I reject the screenshot$/ do
  type 'No'
end

When /^I approve the screenshot$/ do
  type 'Yes'
end

Then /^the new reference screenshot should be the same as the sample generated screenshot$/ do
  sample_generated_file_path = File.join fixture_image_path, 'sample_generated.png'
  new_reference_file_path = File.join current_dir, *%w[artifacts reference_screenshots dir image.png]

  eventually timeout: 1 do
    new_reference_file_path.should be_the_same_file_as sample_generated_file_path
  end
end

Then /^the new reference screenshot should be the same as the original reference screenshot$/ do
  original_reference_file_path = File.join fixture_image_path, 'sample_reference.png'
  new_reference_file_path = File.join current_dir, *%w[artifacts reference_screenshots dir image.png]

  eventually timeout: 1 do
    new_reference_file_path.should be_the_same_file_as original_reference_file_path
  end
end

Then /^the difference image should have been deleted$/ do
  difference_image = File.join current_dir,
		*%w[artifacts differences_in_screenshots_this_run dir image.png_difference.gif]

	difference_image.should_not exist
end

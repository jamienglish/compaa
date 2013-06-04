require 'spec_helper'
require 'capybara'

Dir.chdir 'tmp/homemove' do
  Capybara.app = Compaa::RackApp.new
end
Capybara.current_driver = :selenium

describe "accepting screenshots from the browser" do
  include Capybara::DSL

  before do
    FileUtils.rm_rf('tmp/homemove')
    FileUtils.cp_r('fixtures/homemove', 'tmp/')
  end

  def assert_file_deleted(path)
    refute File.exists?(path), 'Difference image was not deleted'
  end

  def refute_file_deleted(path)
    assert File.exists?(path), 'Difference image should not have been deleted but was'
  end

  def assert_same_file(path1, path2)
    assert FileUtils.compare_file(path1, path2)
  end

  def refute_same_file(path1, path2)
    refute FileUtils.compare_file(path1, path2)
  end

  it "Accepts via clicking accept" do
    Dir.chdir 'tmp/homemove' do
      reference_dir = 'artifacts/reference_screenshots/homemove'
      generated_dir = 'artifacts/screenshots_generated_this_run/homemove'

      visit '/'

      sleep 1

      generated_image = "#{generated_dir}/step_0_moving_home/firefox_Darwin_sky_helpcentre_home_move_getting_started1.png"
      reference_image = "#{reference_dir}/step_0_moving_home/firefox_Darwin_sky_helpcentre_home_move_getting_started1.png"

      assert_match /#{Regexp.escape(generated_image)}$/, page.find('img#generatedImage')['src']

      click_link 'Accept'
      sleep 0.1

      assert_file_deleted generated_image

      generated_image = "#{generated_dir}/step_2_your_new_home/firefox_Darwin_sky_helpcentre_home_move_your_new_home1.png"
      reference_image = "#{reference_dir}/step_2_your_new_home/firefox_Darwin_sky_helpcentre_home_move_your_new_home1.png"

      assert_match /#{Regexp.escape(generated_image)}$/, page.find('img#generatedImage', visible: false)['src']
      assert_match /#{Regexp.escape(reference_image)}$/, page.find('img#referenceImage', visible: false)['src']

      click_link 'Reject'
      sleep 0.1

      refute_file_deleted generated_image
      refute_same_file reference_image, generated_image

      generated_image = "#{generated_dir}/step_4_contact_details/firefox_Darwin_sky_helpcentre_home_move_contact_details1.png"
      reference_image = "#{reference_dir}/step_4_contact_details/firefox_Darwin_sky_helpcentre_home_move_contact_details1.png"

      assert_match /#{Regexp.escape(generated_image)}$/, page.find('img#generatedImage', visible: false)['src']
      assert_match /#{Regexp.escape(reference_image)}$/, page.find('img#referenceImage', visible: false)['src']

      click_link 'Accept'
      sleep 0.1

      assert_file_deleted generated_image

      generated_image = "#{generated_dir}/validation_failures_on_your_new_home/firefox_Darwin_sky_helpcentre_home_move_your_new_home1.png"
      reference_image = "#{reference_dir}/validation_failures_on_your_new_home/firefox_Darwin_sky_helpcentre_home_move_your_new_home1.png"

      assert_match /#{Regexp.escape(generated_image)}$/, page.find('img#generatedImage', visible: false)['src']
      assert_match /#{Regexp.escape(reference_image)}$/, page.find('img#referenceImage', visible: false)['src']

      click_link 'Accept'
      sleep 0.5

      assert_file_deleted generated_image

      assert page.has_selector?('h1', text: 'Done!')
    end
  end
end

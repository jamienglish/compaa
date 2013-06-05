require 'spec_helper'
require 'capybara'
require 'capybara/poltergeist'

FileUtils.mkdir_p('tmp/homemove')
Dir.chdir 'tmp/homemove' do
  Capybara.app = Compaa::RackApp.new
end
Capybara.current_driver = :poltergeist

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

  def generated_dir
    'artifacts/screenshots_generated_this_run/homemove'
  end

  def reference_dir
    'artifacts/reference_screenshots/homemove'
  end

  def assert_generated_becomes_reference(path, &block)
    generated_image = File.binread(File.join(generated_dir, path))
    yield
    reference_image = File.binread(File.join(reference_dir, path))

    assert_equal generated_image, reference_image
    assert_file_deleted File.join(generated_dir, path)
  end

  def assert_reference_doesnt_change(path)
    old = File.binread(File.join(reference_dir, path))
    yield
    new = File.binread(File.join(reference_dir, path))
    generated = File.binread(File.join(generated_dir, path))

    assert_equal old, new
    refute_equal generated, new
  end

  def assert_current_screenshots_are_shown(path)
    generated_image = File.join(generated_dir, path)
    reference_image = File.join(reference_dir, path)

    assert_match /#{Regexp.escape(generated_image)}$/, page.find('img#generatedImage', visible: false)['src']
    assert_match /#{Regexp.escape(reference_image)}$/, page.find('img#referenceImage', visible: false)['src']
  end

  it "Accepts via clicking accept" do
    Dir.chdir 'tmp/homemove' do
      visit '/'

      sleep 0.2

      current_screenshot = 'step_0_moving_home/firefox_Darwin_sky_helpcentre_home_move_getting_started1.png'

      assert_match /#{Regexp.escape(File.join(generated_dir, current_screenshot))}$/,
        page.find('img#generatedImage')['src']

      assert_generated_becomes_reference current_screenshot do
        click_link 'Accept'
      end

      sleep 0.2

      current_screenshot = 'step_2_your_new_home/firefox_Darwin_sky_helpcentre_home_move_your_new_home1.png'

      assert_current_screenshots_are_shown current_screenshot
      assert_reference_doesnt_change current_screenshot do
        click_link 'Reject'
      end

      sleep 0.2

      current_screenshot = 'step_4_contact_details/firefox_Darwin_sky_helpcentre_home_move_contact_details1.png'

      assert_current_screenshots_are_shown current_screenshot
      assert_generated_becomes_reference current_screenshot do
        click_link 'Accept'
      end

      sleep 0.2

      current_screenshot = 'validation_failures_on_your_new_home/firefox_Darwin_sky_helpcentre_home_move_your_new_home1.png'

      assert_current_screenshots_are_shown current_screenshot
      assert_generated_becomes_reference current_screenshot do
        click_link 'Accept'
      end

      sleep 0.2

      assert page.has_selector?('h1', text: 'Done!')
    end
  end
end

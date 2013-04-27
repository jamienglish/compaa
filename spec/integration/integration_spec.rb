require 'spec_helper'
require 'capybara/poltergeist'

Dir.chdir 'tmp/homemove' do
  Capybara.app = Compaa::RackApp.new
end
Capybara.default_driver = :poltergeist

describe "accepting screenshots from the browser" do
  include Capybara::DSL

  before do
    FileUtils.rm_rf('tmp/homemove')
    FileUtils.cp_r('fixtures/homemove', 'tmp/')
  end

  def assert_file_deleted(path)
    timeout = 2
    start_time = Time.now

    begin
      refute File.exists?(path),
        'Difference image was not deleted'
    rescue => e
      retry if (Time.now - start_time) < timeout
      raise
    end
  end

  it "Accepts via clicking accept" do
    Dir.chdir 'tmp/homemove' do
      homemove_dir = 'artifacts/differences_in_screenshots_this_run/homemove'
      visit '/'

      assert_match %r{#{homemove_dir}/step_2_your_new_home/firefox_Darwin_sky_helpcentre_home_move_your_new_home1\.png_difference\.gif$},
        page.find('img#animation', visible: false)['src']

      click_link 'Accept'

      assert_file_deleted "#{homemove_dir}/step_2_your_new_home/firefox_Darwin_sky_helpcentre_home_move_your_new_home1.png_difference.gif"

      assert_match %r{#{homemove_dir}/step_4_contact_details/firefox_Darwin_sky_helpcentre_home_move_contact_details1\.png_difference\.gif$},
        page.find('img#animation', visible: false)['src']

      click_link 'Accept'

      assert_file_deleted "#{homemove_dir}/step_4_contact_details/firefox_Darwin_sky_helpcentre_home_move_contact_details1.png_difference.gif"

      assert_match %r{#{homemove_dir}/validation_failures_on_your_new_home/firefox_Darwin_sky_helpcentre_home_move_your_new_home1\.png_difference\.gif$},
        page.find('img#animation', visible: false)['src']

      click_link 'Accept'

      assert_file_deleted "#{homemove_dir}/validation_failures_on_your_new_home/firefox_Darwin_sky_helpcentre_home_move_your_new_home1\.png_difference\.gif"

      assert page.has_selector?('h1', text: 'Done!')
    end
  end
end

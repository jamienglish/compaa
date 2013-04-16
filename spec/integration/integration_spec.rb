require 'spec_helper'
require 'capybara'

Dir.chdir 'tmp/homemove' do
  Capybara.app = Compaa::RackApp.new
end
Capybara.default_driver = :selenium

describe "accepting screenshots from the browser" do
  include Capybara::DSL

  before do
    FileUtils.rm_rf('tmp/homemove')
    FileUtils.cp_r('fixtures/homemove', 'tmp/')
  end

  it "Accepts via clicking accept" do
    Dir.chdir 'tmp/homemove' do
      homemove_dir = 'artifacts/differences_in_screenshots_this_run/homemove'
      visit '/'

      assert_match %r{#{homemove_dir}/step_2_your_new_home/firefox_Darwin_sky_helpcentre_home_move_your_new_home1.png_difference.gif$},
        page.find('img#animation', visible: false)['src']

      click_button 'Accept'

      assert_equal "#{homemove_dir}/step_4_contact_details/firefox_Darwin_sky_helpcentre_home_move_contact_details1.png_difference.gif",
        page.find('img#animation', visible: false)['src']
    end
  end
end

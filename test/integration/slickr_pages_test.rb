require 'test_helper'

class SlickrPagesTest < ActionDispatch::IntegrationTest
  setup do
    @test_page = Slickr::Page.new(title: 'Test page', layout: 'standard')
  end

  test "has basic previewable options" do
    @test_page.save
    assert_generates '/admin/slickr_pages/test-page/preview_slickr_page', :controller => "admin/slickr_pages", :action => "preview_slickr_page", id: 'test-page'
  end
end

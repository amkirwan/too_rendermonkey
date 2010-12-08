require 'test_helper'

class TooRendermonkeyCssTest < ActiveSupport::TestCase 
  include TooRendermonkeyCss  
  
  def setup
    Rails.logger =Logger.new(STDOUT)
  end 
  
  test "should return css style that is html safe" do
    css_file = ActionView::Base.new.stylesheet_tag_pdf("reports_pdf")
    assert lambda {css_file.html_safe?}
  end   
  
  test "should return empty css if it cannot find the file" do
    css_file = ActionView::Base.new.stylesheet_tag_pdf("does_not_exist.pdf")
    assert_equal "<style type=\"text/css\"></style>", css_file.to_s 
    assert lambda {css_file.html_safe?}
  end
 
end
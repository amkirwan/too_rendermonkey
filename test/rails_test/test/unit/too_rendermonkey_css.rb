require 'test_helper'  

class TooRendermonkeyCss < ActiveSupport::TestCase
  
  test "that the css style is html safe" do
    css_file = ActionView::Base.new.stylesheet_tag_pdf("reports_pdf")
    assert css_file.html_safe?
  end   
 
end
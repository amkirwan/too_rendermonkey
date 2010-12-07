require 'test_helper'   
require 'active_support'      

class InitializerTest < ActiveSupport::TestCase  
     
  test "too rendermonkey initialize" do
    assert_equal 'application/pdf', Mime.const_get(:PDF)
  end 
  
  test "PDFGenerator included in ActionController::Base" do
    assert ActionController::Base.included_modules.include?(PDFGenerator)
  end
  
  test "TooRendermonkeyCss included in ActionView::Base" do
    assert ActionView::Base.included_modules.include?(TooRendermonkeyCss)
  end       
  
  test "too_rendermonkey.rb initializer file is loaded" do   
    assert "Hash", TooRendermonkey.configure.class.to_s
    assert_equal TooRendermonkey.configure.length, 3
  end
  
end  
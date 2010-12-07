require 'test_helper'  

class TooRendermonkeyTest < ActiveSupport::TestCase   
  
  test "should be able to write to configure" do
    TooRendermonkey.configure = "Foobar"
    assert TooRendermonkey.configure, "Foobar"
  end  
  
end




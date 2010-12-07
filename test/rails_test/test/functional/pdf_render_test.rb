require 'test_helper'   
require 'rest-client'  

class PdfRenderTest < ActionController::TestCase

  def setup
    @controller = PDFRenderController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new     
    @filename = "abc" 
    
    TooRendermonkey.configure = {
      :uri => "http://localhost:4567/generate",
      :api_key => "835a3161dc4e71b",
      :hash_key => "sQQTe93eWcpV4Gr5HDjKUh8vu2aNDOvn3+suH1Tc4P4="
    } 
  end                                           
  
  def teardown
    @controller = nil
    @request = nil
    @response = nil
  end  
  
  def request_success
    stub_request(:post, "http://localhost:4567/generate").to_return(
                                                          :body => File.open('./test/functional/abc.pdf'),
                                                          :status => 200, 
                                                          :headers => { 'Content-Length' => File.open('./test/functional/abc.pdf').size.to_s, 
                                                                        'Content-Disposition' => "attachment; filename=#{@filename}"})
  end
  
  def request_fail
    stub_request(:post, "http://localhost:4567/generate").to_return(
                                                          :status => 412,
                                                          :body => "Incorrect or missing parameters")
  end                                                                    
                                                                        
  test "should render with pdf format" do 
    request_success
    get :render_pdf, :format => :pdf      
    assert_response :success 
  end 
  
  test "should render with css" do   
    css_style = '<style type="text/css"> 
                    .bold { font-weight: bold; } 
                 </style>'
    request_success
    get :render_pdf, :format => :pdf             
    assert @controller.pdf_params["page"].gsub(/\s+/, "").include?(css_style.gsub(/\s+/, ""))
  end
  
  # Failures 
  test "should should error message from server on failed request" do  
    request_fail    
    begin
      RestClient.post "http://localhost:4567/generate", {}
      raise
    rescue RestClient::PreconditionFailed => e
      assert_equal e.http_body, "Incorrect or missing parameters"
    end
  end
  
  test "should render 500 on error" do 
    request_fail 
    get :render_pdf, :format => :pdf      
    assert_response :error 
  end     
  
  test "should render 500 on missing configure key" do  
    TooRendermonkey.configure.delete(:api_key)  
    get :render_pdf, :format => :pdf
    assert_response :error
  end  
  
  test "should render 500 on incorrect hash_key" do  
    TooRendermonkey.configure[:hash_key] = "abcdefg"  
    get :render_pdf, :format => :pdf
    assert_response :error
  end
  
end
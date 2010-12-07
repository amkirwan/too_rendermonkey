require 'test_helper' 

class PDFGeneratorTest < ActiveSupport::TestCase
  include PDFGenerator   
  
  ## add required tests
  ## add configure tests
  
  def setup     
    @pdf_name = "pdf name"
    @options = { :pdf_layout => "reports_layout.pdf.erb", :pdf_template => "reports/report.pdf.erb", 
                 :render_options =>  {
                    :header_right => 'Page [page] of [toPage]',
                    :grayscale => true,
                    :page_size => 'Letter'} 
                }  
    @page = "<html><head><head><body><b>Hello</b> World</body></html>" 
    
    TooRendermonkey.configure = {
      :uri => "http://localhost:4567/generate",
      :api_key => "835a3161dc4e71b",
      :hash_key => "sQQTe93eWcpV4Gr5HDjKUh8vu2aNDOvn3+suH1Tc4P4="
    }    
  end       
  
  test "check configuration has values" do 
    generate_params(@pdf_name, @options, @page)
    
    assert TooRendermonkey.configure[:uri], "Configure has uri"
    assert TooRendermonkey.configure[:api_key], "Configure has api_key"
    assert TooRendermonkey.configure[:hash_key], "Configure has hash_key"    
  end    
  
  test "should raise configure error on missing key" do
    TooRendermonkey.configure.delete(:hash_key)
    exception = assert_raise(TooRendermonkey::ConfigureError) { check_configure }  
    assert_match "Configure Error: hash_key", exception.message
  end
  
  test "should generate default params" do
    pdf_params = generate_params(@pdf_name, @options, @page)   
    assert_equal @pdf_name, pdf_params["name"]
    assert_equal @page, pdf_params["page"]  
    assert_equal TooRendermonkey.configure[:api_key], pdf_params["api_key"]
    assert_in_delta Time.now.utc, Time.parse(pdf_params["timestamp"]), 300
    assert_equal 44, pdf_params["signature"].length, 
  end   
  
  test "should process render options" do  
    pdf_params = generate_params(@pdf_name, @options, @page) 
    assert_equal 'Page [page] of [toPage]', pdf_params["header_right"]
    assert_equal "true", pdf_params["grayscale"] 
    assert_equal "Letter", pdf_params["page_size"]
  end  
  
  test "pdf_params all keys should be strings" do
    pdf_params = generate_params(@pdf_name, @options, @page)
    pdf_params.each_key { |key| assert_equal String, key.class, "Key is not a String" }
  end                                                             
  
  test "pdf_params all values should be strings" do
    pdf_params = generate_params(@pdf_name, @options, @page)
    pdf_params.each_value { |value| assert_equal String, value.class, "Value is not a String" }
  end   
  
  test "canonical_querystring" do  
    pdf_params = generate_params(@pdf_name, @options, @page)
    pdf_params["timestamp"] = "2010-12-07T04:37:59Z"
    pdf_params.delete("signature")
    match_string = "api_key=835a3161dc4e71b&grayscale=true&header_right=Page [page] of [toPage]&name=pdf name&page=<html><head><head><body><b>Hello</b> World</body></html>&page_size=Letter&timestamp=2010-12-07T04:37:59Z"
    assert_equal match_string, canonical_querystring(pdf_params) 
  end   
  
  test "generate signature SHA256" do
    # returned in base64 
    assert_equal 44, generate_signature(@options).length
  end       
  
  test "generate signature SHA512" do 
    # returned in base64    
    TooRendermonkey.configure[:hash_key] = "sQQTe93eWcpV4Gr5HDjKUh8vu2aNDOvn3+suH1Tc4P4sQQTe93eWcpV4Gr5HDjKUh8vu2aNDOvn3+suH1Tc4P4aa="
    assert_equal 89, generate_signature(@options).length
  end
  
  test "generate signature SHA1" do
    # returned in base64
    TooRendermonkey.configure[:hash_key] = "sQQTe93eWcpV4Gr5HDjKUh8vu2a="
    assert_equal 28, generate_signature(@options).length
  end 
  
  test "should raise TooRendermonkey::ConfigureError on incorrect hash_key length" do  
    TooRendermonkey.configure[:hash_key] = "sQQTe93eWcpV4Gr5HDjKUh8vu2aN="
    exception = assert_raise(TooRendermonkey::ConfigureError) { generate_signature(@options) }  
    assert_match "Could not match has_key type", exception.message
  end   
     
end

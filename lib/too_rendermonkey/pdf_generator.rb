module PDFGenerator    
  
  attr_reader :pdf_params

  def make_pdf_erb(pdf_name, options = {})     
    options[:pdf_layout] ||= false
    options[:pdf_template] ||= File.join(controller_path, action_name)
    page = render_to_string(:template => options[:pdf_template], :layout => options[:pdf_layout])
    params = generate_params(pdf_name, options, page)
    begin
      response = RestClient.post TooRendermonkey.configure[:uri], params
      send_data response, :type => 'application/pdf', :disposition => "#{response.headers[:content_disposition]}"
    rescue => e     
      logger.info '*'*15 + "ERROR GENERATING PDF: " + e.http_body + '*'*15 
      render :file => "public/500.html", :status => 500
    end
  end

  def generate_params(pdf_name, options, page)
    @pdf_params = { "name" => pdf_name,
                    "page" => page,
                    "api_key" => TooRendermonkey.configure[:api_key],
                    "timestamp" => Time.now.utc.iso8601 }
    process_render_options(options)
    @pdf_params["signature"] = generate_signature(@pdf_params)
    @pdf_params
  end    

  def process_render_options(options) 
    if !options[:render_options].nil? && !options[:render_options].empty?
      options[:render_options].each do |key, value|
        @pdf_params[key.to_s] = value.to_s
      end
    end
  end

  def generate_signature(params)
    c_q = canonical_querystring(params)

    if TooRendermonkey.configure[:hash_key].size == 44
  		#logger.info '*'*10 + "Using SHA256"
  		hashtype = 'SHA256'
  	elsif TooRendermonkey.configure[:hash_key].size == 89
  		#logger.info '*'*10 + "Using SHA512"
  		hashtype = 'SHA512'		
  	elsif  TooRendermonkey.configure[:hash_key].size == 28
  		#logger.info '*'*10 + "Using SHA1"
  		hashtype = 'SHA1'		
  	else
  		raise "Could not match hash type"
  	end

    digest = OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new(hashtype), TooRendermonkey.configure[:hash_key], c_q)
    Base64.encode64(digest).chomp 
  end

  def canonical_querystring(params)
    params.sort.collect do |key, value| [key.to_s, value.to_s].join('=') end.join('&')
  end  
  
end
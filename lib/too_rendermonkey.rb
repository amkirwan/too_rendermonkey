require 'logger'
require 'uri'
require 'net/http'
require 'openssl'
require 'digest/sha2'
require 'base64'
require 'time'

# RendermonkeyToo
module TooRendermonkey
  
  mattr_accessor :config

  def self.included(base)
    base.class_eval do
      alias_method_chain :render, :rendermonkey_too
    end
  end
  
  def render_with_rendermonkey_too(options = nil, *args, &block)
    if options.is_a?(Hash) && options.has_key?(:pdf_template)
      logger.info '*'*15 + 'TOO_RENDERMONKEY' + '*'*15
        make_pdf_erb(options)
      else
        render_without_rendermonkey_too(options, *args, &block)
      end
  end
  
  private
   
  def make_pdf_erb(options = {})
    options[:pdf_layout] ||= false
    options[:pdf_template] ||= File.join(controller_path, action_name)
    page = render_to_string(:template => options[:pdf_template], :layout => options[:pdf_layout])
    
    params = generate_params(options, page)
    
    url = URI.parse(@@config[:uri])
    req = Net::HTTP::Post.new(url.path)
    req.form_data = params
    http = Net::HTTP.new(url.host, url.port)
     #http.use_ssl = true
    begin
      response = http.start {|http| http.request(req)}
      if response.content_type == "text/html"
        logger.info '*'*15 +  response.body + '*'*15
        render :file => "public/500.html"
      else
        send_data response.body, :type => 'pdf', :disposition => 'attachment'
      end
    rescue => e
      logger.info '*'*15 + "ERROR GENERATING PDF: " + e.message + '*'*15
      render :file => "public/500.html"
    end
  end
  
  def generate_params(options, page)
    params = {}
    params["name"] = options[:name] if options.has_key?(:name)
    params["page"] = page
    params["api_key"] = @@config[:api_key]
    params["timestamp"] = Time.now.utc.iso8601
    params["signature"] = generate_signature(params)
    params
  end
  
  def generate_signature(params)
    c_q = canonical_querystring(params)
    
    if @@config[:hash_key].size == 44
  		#logger.info '*'*10 + "Using SHA256"
  		hashtype = 'SHA256'
  	elsif @@config[:hash_key].size == 89
  		#logger.info '*'*10 + "Using SHA512"
  		hashtype = 'SHA512'		
  	elsif  @@config[:hash_key].size == 28
  		#logger.info '*'*10 + "Using SHA1"
  		hashtype = 'SHA1'		
  	else
  		raise "Could not match hash type"
  	end
  	
    digest = OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new(hashtype), @@config[:hash_key], c_q)
    Base64.encode64(digest).chomp 
  end
  
  def canonical_querystring(params)
    params.sort.collect do |key, value| [key.to_s, value.to_s].join('=') end.join('&')
  end
    
end
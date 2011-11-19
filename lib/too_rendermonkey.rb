require 'logger'
require 'uri'
require 'net/http'
require 'openssl'
require 'digest/sha2'
require 'base64'
require 'time'  
require 'rest-client'

# RendermonkeyToo
module TooRendermonkey
  
  mattr_accessor :config, :files

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
    if @@files[options[:tag].to_sym].nil?
      options[:pdf_layout] ||= false
      options[:pdf_template] ||= File.join(controller_path, action_name)
      page = render_to_string(:template => options[:pdf_template], :layout => options[:pdf_layout])
      params = generate_params(options, page)
      begin
        logger.info '*'*15 + 'GENERATE PDF' + '*'*15
        response = RestClient.post @@config[:uri], params
        @@files[options[:tag]] ||= response
        send_data response, :type => 'application/pdf', :disposition => 'attachment',
        :filename => options[:name]
      rescue => e
        logger.info '*'*15 + "ERROR GENERATING PDF: " + e.http_body + '*'*15 
        render :file => "public/500.html"
      end
    else
      begin
        logger.info '*'*15 + 'MEMOIZE PDF' + '*'*15
        send_data @@files[options[:tag]], :type => 'application/pdf', :disposition => 'attachment',
        :filename => options[:name]
      rescue => e
        logger.info '*'*15 + "ERROR GENERATING PDF: " + '*'*15 
        render :file => "public/500.html"
      end
    end
  end
  
  def generate_params(options, page)
    params = {}
    params["name"] = options[:name] if options.has_key?(:name)
    params["page"] = page
    params["api_key"] = @@config[:api_key]
    params["timestamp"] = Time.now.utc.iso8601
    process_render_options(params, options)
    params["signature"] = generate_signature(params)
    params
  end
  
  def process_render_options(params, options) 
    if !options[:render_options].nil? && !options[:render_options].empty?
      options[:render_options].each do |key, value|
        params[key.to_s] = value.to_s
      end
    end
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


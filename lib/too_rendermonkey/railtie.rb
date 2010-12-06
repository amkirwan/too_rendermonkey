require 'logger'
require 'uri'
require 'net/http'
require 'openssl'
require 'digest/sha2'
require 'base64'
require 'time'  
require 'rest-client' 

require 'too_rendermonkey'
require 'rails'

$:.unshift File.join(File.dirname(__FILE__))
require "pdf_generator"
require "too_rendermonkey_css"


module Rails  
  module TooRendermonkey 
    class Railtie < ::Rails::Railtie             
      initializer "add pdf renderer" do         
        ActionController::Renderers.add :pdf do |pdf_name, options|     
          make_pdf_erb(pdf_name, options)
        end  
        Mime::Type.register 'application/pdf', :pdf 
      end  

      config.to_prepare do    
        ActionController::Base.send :include, PDFGenerator
        ActionView::Base.send :include, TooRendermonkeyCss
      end 
      
    end  
  end
end
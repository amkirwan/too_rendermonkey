require 'too_rendermonkey'
require 'logger'
 
$:.unshift File.join(File.dirname(__FILE__)) 
require "pdf_generator"
require "too_rendermonkey_css"


module Rails  
  module TooRendermonkey 
    class Railtie < ::Rails::Railtie             
      initializer "add pdf renderer" do         
        ActionController::Renderers.add :pdf do |pdf_name, options| 
          begin     
            make_pdf_erb(pdf_name, options)
          rescue => e
            logger.info e.message
            render :file => "public/500.html", :status => 500
          end
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
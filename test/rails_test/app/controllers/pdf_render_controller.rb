class PDFRenderController < ApplicationController  
  def render_pdf   
    respond_to do |format|  
      format.pdf do          
        render :pdf => "pdf name", 
               :pdf_layout => "reports_layout.pdf.erb",
               :pdf_template => "reports/report.pdf.erb"
      end
    end
  end
  
end
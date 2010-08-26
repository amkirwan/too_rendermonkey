module TooRendermonkeyCss
  
  def stylesheet_tag_pdf stylesheet
    begin
      css_file = ""
      File.open("#{RAILS_ROOT}/public/stylesheets/#{stylesheet}.css", "r") {|f|
        css_file = f.read
      }
      css_file = '<style type="text/css">' + css_file + '</style>' 
      render :text => css_file
    rescue => err
      puts "Exception: #{err}"
      err
    end
  end
  
end
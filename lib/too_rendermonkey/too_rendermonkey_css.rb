module TooRendermonkeyCss
  
  def stylesheet_tag_pdf stylesheet
    begin
      css_file = ""
      File.open("#{Rails.root.to_s}/public/stylesheets/#{stylesheet}.css", "r") {|f|
        css_file = f.read
      }
      "<style type=\"text/css\"> #{css_file} </style>".html_safe       
    rescue => err
      puts "Exception: #{err}"
      "<style type=\"text/css\"></style>".html_safe
    end
  end
  
end
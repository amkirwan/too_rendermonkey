Gem::Specification.new do |s|
  s.name              = "too_rendermonkey"
  s.version           = "0.1.0"
  s.date              = Time.now.strftime('%Y-%m-%d')
  s.summary           = "Forward HTML renderer to RendemonkeyToo server"
  s.homepage          = "https://github.com/amkirwan/too_rendermonkey"
  s.email             = "amkirwan@gmail.com"
  s.authors           = [ "Anthony M Kirwan" ]
  s.has_rdoc          = false

  s.files             = %w( README.md Rakefile MIT-LICENSE )
  s.files            += Dir.glob("lib/**/*")
  s.files            += Dir.glob("test/**/*") 
  
  s.dependencies 

  s.description       = <<desc
This plugin allows the generation of pdf files from controllers using the pdf mime type. 
This plugin will not generate a pdf but will render the pages specified for the pdf format 
with the extension .pdf.erb as html and forward the request on to the RendermonkeyToo API 
which will generate this page as a PDF. This is useful for having a separate server generate 
PDF files from your Ruby on Rails application. This allows for custom PDF files to be generated 
for the specified page.
desc
end
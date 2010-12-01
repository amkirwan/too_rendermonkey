class TooRendermonkeyGenerator < Rails::Generators::Base  
  
  def self.source_root
    @source_root ||= File.expand_path('../templates', __FILE__)
  end   
  
  def copy_config_files
    copy_file("too_rendermonkey.rb", "config/initializers/too_rendermonkey.rb")
  end

end

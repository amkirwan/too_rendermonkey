class TooRendermonkeyGenerator < Rails::Generator::NamedBase
  def manifest
    record do |m|
      m.file "rendermonkey_too.rb", "config/initializers/rendermonkey_too.rb"
      # m.directory "lib"
      # m.template 'README', "README"
    end
  end
end

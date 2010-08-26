class TooRendermonkeyGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.file "too_rendermonkey.rb", "config/initializers/too_rendermonkey.rb"
    end
  end
end

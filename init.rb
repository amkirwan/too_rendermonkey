# Include hook code here
unless ActionController::Base.instance_methods.include? "render_with_rendermonkey_too"
  require 'rendermonkey_too'
  ActionController::Base.send :include, RendermonkeyToo
end

Mime::Type.register 'application/pdf', :pdf
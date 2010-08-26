# Include hook code here
unless ActionController::Base.instance_methods.include? "render_with_rendermonkey_too"
  require 'too_rendermonkey'
  require 'too_rendermonkey_css'
  ActionController::Base.send :include, RendermonkeyToo
  ActionView::Base.send :include, RendermonkeyCss
end

Mime::Type.register 'application/pdf', :pdf
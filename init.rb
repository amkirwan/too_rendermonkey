# Include hook code here
require 'rendermonkey_too'

unless ActionController::Base.instance_methods.include? "render_with_rendermonkey_too"
  require 'rendermonkey_helper'
  ActionController::Base.send :include, WebmonkeyHelper
end

Mime::Type.register 'application/pdf', :pdf

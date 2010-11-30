module TooRendermonkey
  require 'too_rendermonkey/railtie' if defined?(Rails)  
  
  class << self
    attr_accessor :configure
  end
end
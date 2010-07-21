module RendermonkeyHelper
  require 'rendermonkey_too'
  
  def self.include(base)
    base.class_eval do
      alias_method_chain :render, :rendermonkey_too
  end
  
  def render_with_rendermonkey_too(options = nil, *args, &block)
  end
  
end
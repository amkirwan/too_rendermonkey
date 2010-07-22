require 'logger'

# RendermonkeyToo
module RendermonkeyToo

  def self.included(base)
    base.class_eval do
      alias_method_chain :render, :rendermonkey_too
    end
  end
  
  def render_with_rendermonkey_too(options = nil, *args, &block)
    if options.is_a?(Hash) && options.has_key?(:pdf_layout)
        make_pdf_erb(options)
      else
        render_without_rendermonkey_too(options, *args, &block)
      end
  end
  
  private
   
  def make_pdf_erb(options = {})
    logger.info '*'*15 + 'make_pdf_erb' + '*'*15
    options[:pdf_layout] ||= false
    options[:pdf_template] ||= File.join(controller_path, action_name)
    render :text => render_to_string(:template => options[:pdf_template], :layout => options[:pdf_layout])
  end
  
end
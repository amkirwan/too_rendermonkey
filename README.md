# Rendermonkey Too

## PDF template generation plugin for Ruby on Rails

This plugin allows the generation of pdf files from controllers using the pdf mime type. This plugin will not generate a pdf but will render the pages specified in the options with .pdf.erb as html. This is useful for having a separate server generate PDF files from your Ruby on Rails application. This allows for custom PDF files to be generated for the specified page.

### Installation

  script/plugin install git@github.com:amkirwan/rendermonkey_too.git


### Example

Add for example the following to your controller

Both :pdf_template and :pdf_layout should be specified

  class ExampleController < ApplicationController
    def show
        respond_to do |format|
          format.html # index.html.erb
          format.pdf  do
            render :pdf_template => "reports/phone_list.pdf.erb", 
                   :pdf_layout => "reports.pdf.erb" 
          end
        end
    end
  end

Copyright (c) 2010 [name of plugin creator], released under the MIT license

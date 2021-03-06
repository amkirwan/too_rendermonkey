# TooRendermonkey

## PDF template generation plugin for Ruby on Rails 

### Master tracks Rails 3. Branch Rails 2 tracks >= Rails 2.3.5

This plugin allows the generation of pdf files from controllers using the pdf mime type. This plugin will not generate a pdf but will render the pages specified for the pdf format with the extension .pdf.erb as html and forward the request on to the RendermonkeyToo API which will generate this page as a PDF. This is useful for having a separate server generate PDF files from your Ruby on Rails application. This allows for custom PDF files to be generated for the specified page.

### Installation as gem
	gem install too_rendermonkey
	rails generate too_rendermonkey  
	
### Installation as plugin
    rails plugin install git://github.com/amkirwan/too_rendermonkey.git
    rails generate too_rendermonkey
    
    #In your Rails project Gemfile add
    gem 'too_rendermonkey', :path=>'vendor/plugins/too_rendermonkey'
    

Generate will install a file in config/initializers/too_rendermonkey.rb. The following params must be specified in this file to generate PDFs using the RendermonkeyToo API.

* URI of the RendermonkeyToo instance which is running
* api_key given from the RendermonkeyToo API
* hash_key (secret key) given from the RendermonkeyToo API. This key is used to hash all the params sent to the RendermonkeyToo API when generating a PDF. Keep this key secure. 


### Example
                                            
Setup the Rails initializer config/initializers/too_rendermonkey.rb after running script/generate too_rendermonkey. Use your API info from RendermonkeyToo to configure. Make sure to keep the hash_key secure. Anytime you edit this file you will need to restart the server.

	TooRendermonkey.config = {
  		:uri => "http://localhost:4567/generate",
  		:api_key => "abcdefg",
  		:hash_key => "abcdefg123456789"
	}

In your controller within the action that you want to generate a PDF you would need to specify the following
*render :pdf, :pdf_template and :pdf_layout need to be specified*

    class ExampleController < ApplicationController
        def show
            respond_to do |format|
                format.html #index.html.erb
                format.pdf  do
				   render :pdf  => "Phone List",
						  :pdf_layout => "reports.pdf.erb",
						  :pdf_template => "reports/phone_list.pdf.erb",
						  :render_options => {
							:header_right => 'Page [page] of [toPage]',
							:grayscale => true
						  }
                end
            end
        end
    end

In your view code you can specify the PDF path like in the example below. This will generate a PDF request.
	<div>
		<ul>
			<li class="reports">Department Phone List</li>
			<li class="reports-type"><%= link_to "Web", phone_list_reports_path %></li>
			<li class="reports-type"><%= link_to "PDF", phone_list_reports_path(:pdf) %></li>
		</ul>
	</div>
	
For the PDF templates you will need to include the css within the document so that it can be formatted correctly since the document is being sent to a server to be generated. 

Use the RendermonkeyToo helper *stylesheet_tag_pdf* within your pdf_layout to accomplish this. Specify the name of the pdf file and it will automatically read in your css into the document.

	<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
		<head>
			<meta http-equiv="content-type" content="text/html;charset=UTF-8" />
			<%= stylesheet_tag_pdf "reports_pdf" %>
		</head>
		
The pdf_template can have links to partial .html.erb files so you do not need to duplicate all your pages. You must however add in a .html extension to any partials you are includeing.

	<div class="list-wrap">
		<%= render(:partial => "col_one_subheading.html", :object => "Faculty") %>
		<div class="section-wrap">
			<%= render(:partial => "report_column_one.html", :object => @all_faculty_column_one)  %>
			<%= render(:partial => "report_column_two.html", :object => @all_faculty_column_two)  %>
			<%= render(:partial => "report_column_three.html", :object => @all_faculty_column_three)  %>
		</div>
	</div>
	
### Plugin Params - Troubleshooting

When generating a request the plugin sends the following params to the TooRendermonkey API

* api_key (your api_key)
* timestamp (Time request generated, iso8601)
* page - (HTML to render to PDF)
* name - (Name of PDF file) Only Param that is optional
* signature - (SHA256 HMAC generated using your hash_key plus all the params of the current request )

If the request generated takes longer than 5 minutes to arrive at the Rendermonkey API server it will be rejected. This is to prevent someone from attempting to replay your request.

All of this will be handled for you by the plugin. If there are any errors with your params the Rendermonkey API will respond with a message stating the reason for failure.



Copyright (c) 2010 [Anthony Kirwan], released under the MIT license

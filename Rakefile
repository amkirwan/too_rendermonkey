require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "too_rendermonkey"
  gem.homepage = "http://github.com/amkirwan/too_rendermonkey"
  gem.license = "MIT"
  gem.summary = %Q{Forward HTML renderer to RendemonkeyToo server}
  gem.email = "amkirwan@gmail.com"
  gem.authors = ["Anthony Kirwan"] 
  gem.description = %Q{This plugin allows the generation of pdf files from controllers using the pdf mime type. 
  This plugin will not generate a pdf but will render the pages specified for the pdf format 
  with the extension .pdf.erb as html and forward the request on to the RendermonkeyToo API 
  which will generate this page as a PDF. This is useful for having a separate server generate 
  PDF files from your Ruby on Rails application. This allows for custom PDF files to be generated 
  for the specified page.}
  gem.add_runtime_dependency 'rest-client', '~> 1.6.1'
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

require 'rcov/rcovtask'
Rcov::RcovTask.new do |test|
  test.libs << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "too_rendermonkey #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

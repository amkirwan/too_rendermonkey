# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{too_rendermonkey}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Anthony Kirwan"]
  s.date = %q{2010-11-22}
  s.description = %q{This plugin allows the generation of pdf files from controllers using the pdf mime type. 
  This plugin will not generate a pdf but will render the pages specified for the pdf format 
  with the extension .pdf.erb as html and forward the request on to the RendermonkeyToo API 
  which will generate this page as a PDF. This is useful for having a separate server generate 
  PDF files from your Ruby on Rails application. This allows for custom PDF files to be generated 
  for the specified page.}
  s.email = %q{amkirwan@gmail.com}
  s.extra_rdoc_files = [
    "README.md"
  ]
  s.files = [
    "Gemfile",
    "Gemfile.lock",
    "MIT-LICENSE",
    "README.md",
    "Rakefile",
    "VERSION",
    "generators/too_rendermonkey/USAGE",
    "generators/too_rendermonkey/templates/too_rendermonkey.rb",
    "generators/too_rendermonkey/too_rendermonkey_generator.rb",
    "init.rb",
    "install.rb",
    "lib/too_rendermonkey_css.rb",
    "rails/init.rb",
    "tasks/rendermonkey_too_tasks.rake",
    "test/rendermonkey_too_test.rb",
    "test/test_helper.rb",
    "too_rendermonkey.gemspec",
    "uninstall.rb"
  ]
  s.homepage = %q{http://github.com/amkirwan/too_rendermonkey}
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Forward HTML renderer to RendemonkeyToo server}
  s.test_files = [
    "test/rendermonkey_too_test.rb",
    "test/test_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.5.1"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
      s.add_runtime_dependency(%q<rest-client>, ["~> 1.6.1"])
    else
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.5.1"])
      s.add_dependency(%q<rcov>, [">= 0"])
      s.add_dependency(%q<rest-client>, ["~> 1.6.1"])
    end
  else
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.5.1"])
    s.add_dependency(%q<rcov>, [">= 0"])
    s.add_dependency(%q<rest-client>, ["~> 1.6.1"])
  end
end


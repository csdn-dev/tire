# -*- encoding: utf-8 -*-
$:.unshift File.expand_path("../lib", __FILE__)
require "tire/version"

Gem::Specification.new do |s|
  s.name        = "csdn-tire"
  s.version     = Tire::VERSION
  s.platform    = Gem::Platform::RUBY
  s.summary     = "Ruby client for CSDNSearch"
  s.homepage    = "https://github.com/csdn-dev/tire"
  s.authors     = [ 'Hooopo' ]
  s.email       = 'wangxz@csdn.net'

  s.rubyforge_project = "tire"

  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }

  s.require_paths = ["lib"]

  s.extra_rdoc_files  = [ "README.markdown", "MIT-LICENSE" ]
  s.rdoc_options      = [ "--charset=UTF-8" ]

  s.required_rubygems_version = ">= 1.3.6"

  # = Library dependencies
  #
  s.add_dependency "rake"
  s.add_dependency "rest-client",    "~> 1.6"
  s.add_dependency "multi_json",     "~> 1.0"
  s.add_dependency "hashr",          "~> 0.0.19"
  s.add_dependency "activesupport",  ">= 2.3"

  # = Development dependencies
  #
  s.add_development_dependency "bundler",     "~> 1.0"
  s.add_development_dependency "yajl-ruby",   "~> 1.0"
  s.add_development_dependency "shoulda"
  s.add_development_dependency "mocha"
  s.add_development_dependency "bson_ext"
  s.add_development_dependency "minitest"


  s.description = <<-DESC
   Tire is a Ruby client for the CSDNSearch search engine/database.
  DESC
end

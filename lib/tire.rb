require 'rest_client'
require 'multi_json'
require 'hashr'
require 'cgi'

require 'active_support/core_ext'

# Ruby 1.8 compatibility
require 'tire/rubyext/ruby_1_8' if defined?(RUBY_VERSION) && RUBY_VERSION < '1.9'
require 'tire/rubyext/to_json'
require 'tire/utils'
require 'tire/logger'
require 'tire/configuration'
require 'tire/http/response'
require 'tire/http/client'
require 'tire/search'
require 'tire/count'
require 'tire/general_search'
require 'tire/general_search/search_params'
require 'tire/general_search/blog_search'
require 'tire/results/pagination'
require 'tire/index'
require 'tire/dsl'

module Tire
  extend DSL
end

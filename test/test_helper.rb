# -*- encoding : utf-8 -*-
require 'rubygems'
require 'bundler/setup'

require 'test/unit'

require 'yajl'
#require 'yajl/json_gem'

require 'shoulda'
require 'turn/autorun' unless  defined?(RUBY_VERSION) && RUBY_VERSION < '1.9'
require 'mocha'

require 'tire'

class Test::Unit::TestCase

  def mock_response(body, code=200, headers={})
    Tire::HTTP::Response.new(body, code, headers)
  end

end

module Test::Integration
  URL = "http://192.168.6.35:9400"
  INDEX = "articles_test"

  def setup
    ENV['ELASTICSEARCH_URL'] = URL
    @index = Tire.index(INDEX)
  end

  def regist_shard
    @index.delete
    @index.regist_shard(6)
  end

  def create_mapping

  end

  def bulk_data
    
  end

  def teardown
    ::RestClient.delete "#{URL}/#{INDEX}" rescue nil
  end
end

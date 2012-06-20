# -*- encoding : utf-8 -*-
require 'rubygems'
require 'bundler/setup'

require 'test/unit'

require 'yajl'
#require 'yajl/json_gem'

require 'shoulda'
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
  TYPE = "type_test"

  def setup
    Tire::Configuration.url(URL)
    @index = Tire.index(INDEX)
  end

  def setup_shard
    @index.regist_shard(6)
  end

  def setup_mapping
    mapping = {TYPE => {"_source"=>{"enabled"=>false},
        "properties"=>
          {"title"=>
            {"type"=>"string",
            "term_vector"=>"with_positions_offsets",
            "boost"=>2.0},
          "body"=>{"type"=>"string", "term_vector"=>"with_positions_offsets"},
          "username"=>{"type"=>"string", "index"=>"not_analyzed", "store"=>"no"},
          "id"=>
            {"type"=>"integer", "index"=>"not_analyzed", "include_in_all"=>false},
          "created_at"=>
            {"type"=>"integer", "index"=>"not_analyzed", "include_in_all"=>false}
        }
      }
    }
    setup_shard
    @index.create_mapping(TYPE, mapping)
  end

  def setup_bulk
    doc = [
      {"title"=>"java 是好东西",
        "body"=>"hey java",
        "id"=>"1",
        "username"=>"jack",
        "created_at"=>2007072323},
      {"title"=>"this java cool",
        "body"=>"hey java",
        "id"=>"2",
        "created_at"=>2009072323,
        "username"=>"robbin"},
      {"title"=>"this is java cool",
        "body"=>"hey java",
        "id"=>"3",
        "created_at"=>2010072323,
        "username"=>"www"},
      {"title"=>"java is really cool",
        "body"=>"hey java",
        "id"=>"4",
        "created_at"=>2007062323,
        "username"=>"google"},
      {"title"=>"this is wakak cool",
        "body"=>"hey java",
        "id"=>"5",
        "created_at"=>2007062323,
        "username"=>"jackde"},
      {"title"=>"this is java cool",
        "body"=>"hey java",
        "id"=>"6",
        "created_at"=>2007012323,
        "username"=>"jackk wa"},
      {"title"=>"this java really cool",
        "body"=>"hey java",
        "id"=>"7",
        "created_at"=>2002072323,
        "username"=>"william"}
    ]
    setup_mapping
    @index.bulk(TYPE, doc)
  end


  def teardown
    ::RestClient.delete "#{URL}/#{INDEX}" rescue nil
  end
end

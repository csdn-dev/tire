# -*- encoding : utf-8 -*-
require 'test_helper'

module Tire

  class SearchIntegrationTest < Test::Unit::TestCase
    include Test::Integration

    context "search" do
      should "search results" do
        setup_bulk
        @index.refresh

        max_size = 4
        query = "java"

        search = Tire.search(INDEX, TYPE, %Q!{"query":{"text":{"title":"#{query}"}},"size":#{max_size},"from":0}!)

        results = search.results
        assert_kind_of Hash, results
        assert results["total"] > 0
        assert_kind_of Array, results["hits"]

        hits_count = DOC.select{|item| item["title"] =~ /#{query}/}.size

        assert_equal hits_count, results["total"]
        assert_equal max_size, results["hits"].size
      end
    end
  end
end

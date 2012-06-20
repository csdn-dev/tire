# -*- encoding : utf-8 -*-
require 'test_helper'

module Tire

  class SearchIntegrationTest < Test::Unit::TestCase
    include Test::Integration

    context "search" do
      should "search results" do
        setup_bulk
        @index.refresh
        search = Tire.search(INDEX, TYPE, '{"query":{"text":{"title":"java"}},"size":4,"from":0}')
        results = search.results
        assert_kind_of Hash, results
        assert results["total"] > 0
        assert_kind_of Array, results["hits"]
        assert_equal 6, results["total"]
        assert_equal 4, results["hits"].size
      end
    end
  end
end

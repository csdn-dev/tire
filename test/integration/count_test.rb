# -*- encoding : utf-8 -*-
require 'test_helper'

module Tire

  class CountIntegrationTest < Test::Unit::TestCase
    include Test::Integration

    context "count" do
      should "count results" do
        setup_bulk
        @index.refresh
        count = Tire.count(INDEX, TYPE, '{"query":{"text":{"title":"java"}},"size":4,"from":0}')
        num = count.results
        assert_kind_of Integer, num
        assert_equal 6, num
      end
    end
  end
end

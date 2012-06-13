# -*- encoding : utf-8 -*-
require 'test_helper'

module Tire

  class StateIntegrationTest < Test::Unit::TestCase
    include Test::Integration

    context "state" do
      should "get short state" do
        assert_kind_of Array, Tire.state.info
        assert_kind_of Hash, Tire.state.info.first
      end

      should "get more state" do
        assert_kind_of Array, Tire.state.info(true)
        assert_kind_of Hash, Tire.state.info(true).first
        assert_not_nil Tire.state.info(true).first["blog"]
      end
    end
  end
end

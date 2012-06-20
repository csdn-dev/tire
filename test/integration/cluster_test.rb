# -*- encoding : utf-8 -*-
require 'test_helper'

module Tire

  class ClusterIntegrationTest < Test::Unit::TestCase
    include Test::Integration

    context "cluster" do
      should "get host" do
        assert_kind_of Hash, Tire::Cluster.host
      end

      should  "get  index list" do
        assert_kind_of Array, Tire::Cluster.index
      end

      should "get short state" do
        assert_kind_of Array, Tire::Cluster.state
        assert_kind_of Hash, Tire::Cluster.state.first
      end

      should "get more state" do
        assert_kind_of Array, Tire::Cluster.state(true)
        assert_kind_of Hash, Tire::Cluster.state(true).first
        assert_not_nil Tire::Cluster.state(true).first["blog"]
      end

    end
  end
end
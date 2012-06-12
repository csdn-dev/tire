# -*- encoding : utf-8 -*-
require 'test_helper'

module Tire

  class IndexIntegrationTest < Test::Unit::TestCase
    include Test::Integration

    context "index" do

      should "regist_shard" do
        assert @index.regist_shard(6)
      end

      should "not regist exist index" do
        @index.regist_shard(6)
        assert !@index.regist_shard(6)
      end

      should "delete index" do
        assert @index.delete
      end

      should "get shard info" do
        @index.regist_shard(6)
        assert_kind_of Array, @index.shard_info
        assert !@index.shard_info.empty?
      end

    end

  end

end

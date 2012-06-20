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

      should "create mapping" do
        assert setup_mapping
      end

      should "get mapping info" do
        setup_mapping
        assert_kind_of Hash, @index.mapping(TYPE)
        assert_not_nil @index.mapping(TYPE)[TYPE]
      end

      should "bulk insert" do
        assert setup_bulk
      end

      should "flush index" do
        setup_bulk
        assert @index.flush
      end

      should "refresh index" do
        setup_bulk
        assert @index.refresh
      end
    end

  end

end

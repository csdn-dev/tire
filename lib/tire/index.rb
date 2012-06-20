# -*- encoding : utf-8 -*-
module Tire
  class Index
    include Utils
    
    attr_reader :name, :response

    def initialize(name)
      @name = name
    end

    def url
      "#{Configuration.url}/#{@name}"
    end

    def regist_shard(total = 6)
      notes_count = Configuration.nodes_count
      regist_json = MultiJson.encode(build_regist_options(total, notes_count))
      @response = Configuration.client.put("#{url}/_shard", regist_json)
      @response.success?

    ensure
      curl = %Q|curl -X PUT "#{url}/_shard" -d '#{regist_json}'|
      logged('_regist_shard', curl)
    end

    def shard_info
      @response = Configuration.client.get("#{url}/_shard")
      if @response.failure?
        STDERR.puts "[REQUEST FAILED] \n"
        raise @response.to_s
      end
      
      MultiJson.decode(@response.body)
    ensure
      curl = %Q|curl -X GET #{url}/_shard|
      logged('_regist_shard_info', curl)
    end

    def delete
      @response = Configuration.client.delete url
      @response.success?

    ensure
      curl = %Q|curl -X DELETE #{url}|
      logged('DELETE', curl)
    end

    def mapping(type = "csdn")
      @response = Configuration.client.get("#{url}/#{type}/_mapping")
      MultiJson.decode(@response.body)
    end

    def create_mapping(type, options)
      @options = options
      @response = Configuration.client.put("#{url}/#{type}/_mapping", MultiJson.encode(options))
      @response.success?

    ensure
      curl = %Q|curl -X PUT #{url}/#{type}/_mapping -d '#{MultiJson.encode(options)}'|
      logged('CREATE MAPPING', curl)
    end

    def bulk(type, document)
      @response = Configuration.client.put("#{url}/#{type}/_bulk", MultiJson.encode(document))
      @response.success?

    ensure
      curl = %Q|curl -X PUT #{url}/#{type}/_pulk -d '#{MultiJson.encode(document)}'|
      logged('BULK', curl)
    end

    def flush
      @response = Configuration.client.put("#{url}/_flush", "")
      @response.success?

    ensure
      curl = %Q|curl -X PUT #{url}/_flush|
      logged('FLUSH', curl)
    end

    def refresh
      @response = Configuration.client.put("#{url}/_refresh", "")
      @response.success?

    ensure
      curl = %Q|curl -X PUT #{url}/_refresh|
      logged('REFRESH', curl)
    end

    private

    def build_regist_options(total, notes_count)
      Hash[(0..total - 1).group_by{|x| x.modulo notes_count}.map{|key, value| ["cs#{key + 1}", value]}]
    end

  end
end

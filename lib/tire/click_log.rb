# -*- encoding : utf-8 -*-
module Tire
  class ClickLog
    include Utils

    def initialize(indices, types, keyword, ids)
      @indices = Array(indices)
      @types   = Array(types).map { |type| Utils.escape(type) }

      @path    = ['/', @indices.join(','), @types.join(','), '_log'].compact.join('/').squeeze('/')
      @payload = MultiJson.encode({:keyword => keyword, :id => ids.split(',')})
    end

    def url
      "#{Configuration.url}#@path"
    end

    def log
      @response = Configuration.client.post(url, @payload)
      if @response.success?
        MultiJson.decode(@response.body)
      else
        []
      end
    ensure
      curl = %Q(curl -X POST #{url} -d '#{@payload}')
      logged('CLICK_LOG', curl)
    end
  end
end

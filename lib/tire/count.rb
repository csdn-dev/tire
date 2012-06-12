# -*- encoding : utf-8 -*-
module Tire
  class SearchRequestFailed < StandardError; end

  class Count < Search

    def initialize(indices, types, payload)
      @indices = Array(indices)
      @types   = Array(types).map { |type| Utils.escape(type) }
      if payload.is_a?(String)
        @payload = payload
      else
        @payload_hash = payload
      end

      @path    = ['/', @indices.join(','), @types.join(','), '_count'].compact.join('/').squeeze('/')
    end

    def results
      perform
      return @json["totalHits"]
    end
  end
end

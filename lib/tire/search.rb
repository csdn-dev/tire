# -*- encoding : utf-8 -*-
module Tire
  class SearchRequestFailed < StandardError; end

  class Search

    attr_reader :payload, :payload_hash, :indices

    def initialize(indices, types, payload)
      @indices = Array(indices)
      @types   = Array(types).map { |type| Utils.escape(type) }
      if payload.is_a?(String)
        @payload = payload
      else
        @payload_hash = payload
      end

      @path    = ['/', @indices.join(','), @types.join(','), '_search'].compact.join('/').squeeze('/')
    end

    def results
      @json  || (perform; @json)
    end

    def response
      @response || (perform; @response)
    end

    def url
      Configuration.url + @path
    end

    def perform
      @response = Configuration.client.get(self.url, self.payload)
      if @response.failure?
        STDERR.puts "[REQUEST FAILED] #{self.to_curl}\n"
        raise SearchRequestFailed, @response.to_s
      end
      @json     = MultiJson.decode(@response.body)
      return @json
    ensure
      logged
    end

    def to_curl
      %Q|curl -X GET #{url} -d '#{payload}'|
    end

    def payload
      @payload || MultiJson.encode(@payload_hash)
    end

    def to_hash
      @hash_payload ||= MultiJson.decode(payload)
    end

    def logged(error=nil)
      if Configuration.logger

        Configuration.logger.log_request '_search', indices, to_curl

        code = @response.code rescue nil

        if Configuration.logger.level.to_s == 'debug'
          # FIXME: Depends on RestClient implementation
          body = if @json
            defined?(Yajl) ? Yajl::Encoder.encode(@json, :pretty => true) : MultiJson.encode(@json)
          else
            @response.body rescue nil
          end
        else
          body = ''
        end

        Configuration.logger.log_response code || 'N/A', "N/A", body || 'N/A'
      end
    end

  end
end

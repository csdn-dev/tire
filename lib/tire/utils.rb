# -*- encoding : utf-8 -*-
require 'uri'

module Tire
  module Utils

    def escape(s)
      URI.encode_www_form_component(s.to_s)
    end

    def unescape(s)
      s = s.to_s.respond_to?(:force_encoding) ? s.to_s.force_encoding(Encoding::UTF_8) : s.to_s
      URI.decode_www_form_component(s)
    end

    def logged(endpoint='/', curl='')
      if Configuration.logger
        error = $!

        Configuration.logger.log_request endpoint, @name, curl

        code = @response ? @response.code : error.class rescue 200

        if Configuration.logger.level.to_s == 'debug'
          body = if @response
            defined?(Yajl) ? Yajl::Encoder.encode(@response.body, :pretty => true) : MultiJson.encode(@response.body)
          else
            error.message rescue ''
          end
        else
          body = ''
        end

        Configuration.logger.log_response code, nil, body
      end
    end

    module_function :escape, :unescape
  end
end

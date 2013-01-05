# -*- encoding : utf-8 -*-
require 'timeout'
module Tire

  module HTTP

    module Client
      class RequestTimeout < Timeout::Error ; end

      class RestClient
        ConnectionExceptions = [::RestClient::ServerBrokeConnection, ::RestClient::RequestTimeout]

        def self.get(url, data=nil)
          perform http_execute(:method => :get, :url => url, :payload => data)
        rescue *ConnectionExceptions
          raise
        rescue ::RestClient::Exception => e
          Response.new e.http_body, e.http_code
        end

        def self.post(url, data)
          perform http_execute(:method => :post, :url => url, :payload => data)
        rescue *ConnectionExceptions
          raise
        rescue ::RestClient::Exception => e
          Response.new e.http_body, e.http_code
        end

        def self.put(url, data)
          perform http_execute(:method => :put, :url => url, :payload => data)
        rescue *ConnectionExceptions
          raise
        rescue ::RestClient::Exception => e
          Response.new e.http_body, e.http_code
        end

        def self.delete(url)
          perform http_execute(:method => :delete, :url => url)
        rescue *ConnectionExceptions
          raise
        rescue ::RestClient::Exception => e
          Response.new e.http_body, e.http_code
        end

        def self.head(url)
          perform http_execute(:method => :head, :url => url)
        rescue *ConnectionExceptions
          raise
        rescue ::RestClient::Exception => e
          Response.new e.http_body, e.http_code
        end

        def self.default_headers
          {"X-ACL-TOKEN" => Configuration.x_acl_token}
        end

        private

        def self.perform(response)
          timeout(Configuration.timeout_sec, RequestTimeout) do
            Response.new response.body, response.code, response.headers
          end
        end

        def self.http_execute(args)
          args[:headers] ||= {}
          args[:headers].merge!(default_headers)
          ::RestClient::Request.execute(args)
        end

      end

    end

  end

end

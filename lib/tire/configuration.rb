# -*- encoding : utf-8 -*-
module Tire

  class Configuration
    def self.url(value=nil)
      @url = (value ? value.to_s.gsub(%r|/*$|, '') : nil) || @url || ENV['CSDNSEARCH_URL'] || "http://localhost:9200"
    end

    def self.client(klass=nil)
      @client = klass || @client || HTTP::Client::RestClient
    end

    def self.logger(device=nil, options={})
      return @logger = Logger.new(device, options) if device
      @logger || nil
    end

    def self.reset(*properties)
      reset_variables = properties.empty? ? instance_variables : instance_variables.map { |p| p.to_s} & \
                                                                 properties.map         { |p| "@#{p}" }
      reset_variables.each { |v| instance_variable_set(v.to_sym, nil) }
    end

    def self.timeout_sec(value=nil)
      @timeout_sec = value || @timeout_sec || 10
    end

    def self.x_acl_token(value=nil)
      @x_acl_token = value || @x_acl_token || raise(ArgumentError, "must init X ACL Token")
    end

  end

end

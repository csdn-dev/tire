# -*- encoding : utf-8 -*-
module Tire
  class Cluster
    extend Utils
    
    def self.url
      "#{Configuration.url}/cluster"
    end

    # [{"host":"192.168.6.35","master":false,"online":false,"port":9500},{"host":"192.168.6.35","master":false,"online":true,"port":9400}]
    def self.state(more = false)
      desc_url = more ? "#{url}/_state?more=true" : "#{url}/_state?more=false"
      @response = Configuration.client.get(desc_url)
      if @response.success?
        MultiJson.decode(@response.body)
      else
        []
      end
    ensure
      curl = %Q|curl -X GET #{desc_url}|
      logged('CLUSTER_STATE', curl)
    end

    # ["news","blog","ask"]
    def self.index
      desc_url = "#{url}/_index"

      @response = Configuration.client.get(desc_url)
      if @response.failure?
        STDERR.puts "[REQUEST FAILED] \n"
        raise @response.to_s
      end

      MultiJson.decode(@response.body)
    ensure
      curl = %Q|curl -X GET #{desc_url}|
      logged('CLUSTER INDEX', curl)
    end

    # {"cs2":{"host":"192.168.6.35","master":false,"online":false,"port":9500},"cs1":{"host":"192.168.6.35","master":false,"online":true,"port":9400}}
    def self.host
      path = "#{url}/_host"

      @response = Configuration.client.get(path)
      if @response.failure?
        STDERR.puts "[REQUEST FAILED] \n"
        raise @response.to_s
      end

      MultiJson.decode(@response.body)
    ensure
      curl = %Q|curl -X GET #{path}|
      logged('CLUSTER HOST', curl)
    end
  end
end

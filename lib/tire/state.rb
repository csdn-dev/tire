module Tire
  class State
    include Utils
    
    def initialize

    end

    def url
      "#{Configuration.url}/cluster/_state"
    end

    def info(more = false)
      desc_url = more ? "#{url}?more=true" : "#{url}?more=false"
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
  end
end
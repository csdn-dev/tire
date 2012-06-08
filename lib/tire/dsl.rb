module Tire
  module DSL

    def configure(&block)
      Configuration.class_eval(&block)
    end
    
    def index(name)
      Index.new(name)
    end

    def search(names, types, payload)
      Search.new(names, types, payload)
    end

  end
end

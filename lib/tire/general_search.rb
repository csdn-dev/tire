module Tire
  module GeneralSearch
    class Search
      attr_reader :search_engine
      # keyword,type,page,per_page,sort
      def initialize(options={})
        search_type = options[:search_type] || :all
        @search_engine = case search_type.to_sym
                         when :blog
                           BlogSearch.new(options)
                         end
      end

      def results
        @search_engine.results
      end
    end
  end
end

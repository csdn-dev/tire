module Tire
  module GeneralSearch
    class BlogSearch
      include GeneralSearch
      attr_reader :search_params

      def initialize(options)
        @search_params = {}
        @options = options
        @keyword = @options[:keyword]
        @page = @options[:page] ||=1
        @per_page = @options[:per_page] ||= 20
        @sort = @options[:sort]
        parse_keyword
        query_params.filter_params.page_params.sort_params
      end

      def url
        @@url ||= "#{Configuration.url}/blog/csdn/_search"
      end

      def query_params
        @query_params = {}
        if @search_field
          case @search_field.first
          when 'title'
            @query_params = {:text => {:title => @keyword}}
          else #blog use filter
            @query_params = {:text => {:title => @keyword, :body => @keyword}}
          end
        else
          @query_params = {:text => {:title => @keyword, :body => @keyword}}
        end
        @search_params[:query] = @query_params
        self
      end

      def filter_params
        @filter_params = {:bool => {:should => [{:term => {:status => 0}}, {:term => {:status => 1} } ] } }
        if @search_field && @search_field.first == 'blog'
          @filter_params[:bool][:must] = { :term => { :user_name => @search_field[1] } }
        end
        @search_params[:filter] = @filter_params
        self
      end

      def perform
        @response = Configuration.client.post(self.url, self.search_params.to_json)
      end

    end

  end
end

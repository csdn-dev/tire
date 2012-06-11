module Tire
  module GeneralSearch
    TITLE_REGEXP = /^title:(.+)/
    BLOG_REGEXP = /^blog:([^ ]+)\s+(.+)/

    def keyword_blank?
      @keyword.blank?
    end

    protected
    def gbk2utf8(q)
      if q.unpack('U*')
        q
      else #unpack result is empty
        Iconv.conv("UTF-8", "GB18030", q) 
      end
    rescue # unpack fail
      Iconv.conv("UTF-8", "GB18030", q) rescue ''
    end

    def parse_keyword
      return if @parse_keyword_ran
      @parse_keyword_ran = true
      @keyword = gbk2utf8(@keyword)

      case @keyword
      when TITLE_REGEXP # title:keyword
        matches = TITLE_REGEXP.match(title_regexp)
        @search_field = ['title', matches[1]]
        @keyword = matches[1]
      when BLOG_REGEXP # blog:username keyword
        matches = BLOG_REGEXP.match(blog_regexp)
        @search_field = ['blog', matches[1], matches[2]]
        @keyword = matches[2]
      end

      self
    end

    def query_params
      raise 'no implement'
    end

    def filter_params
      raise 'no implement'
    end

    def page_params
      @search_params[:from] = (@page - 1) * @per_page
      @search_params[:size] = @per_page
      self
    end

    def sort_params
      @search_params[:sort] = {@sort => 'desc'} if @sort && @sort == 'created_at'
      self
    end
  end
end

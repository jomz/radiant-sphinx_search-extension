module SphinxSearch
  class LinkRenderer < Radiant::Pagination::LinkRenderer
    def initialize(url_stem, query)
      @url_stem, @query = url_stem, query
    end

    def page_link(page, text, attributes = {})
      linkclass = %{ class="#{attributes[:class]}"} if attributes[:class]
      linkrel = %{ rel="#{attributes[:rel]}"} if attributes[:rel]
      page_param_name = WillPaginate::ViewHelpers.pagination_options[:param_name]
      search_param_name = Radiant::Config['search.param_name'] || 'q'
      %Q{<a href="#{@url_stem}?#{search_param_name}=#{@query}&#{page_param_name}=#{page}"#{linkrel}#{linkclass}>#{text}</a>}
    end

  end
end
module SphinxSearch
  module RadiusTags
    include Radiant::Taggable
    include ActionView::Helpers::TextHelper

    desc %{
      Opens the array of search results.
    }
    tag 'results' do |tag|
      options = thinking_sphinx_options(tag)
      tag.locals.query = tag.globals.page.request[Radiant::Config['search.param_name'].to_sym]
      paging = pagination_find_options(tag)
      if paging
        options.merge!(paging)
        tag.locals.pagination_opts = will_paginate_options(tag)
      end
      tag.locals.results ||= ThinkingSphinx.search(tag.locals.query, options)
      tag.expand
    end

    desc %{
      Displays the total number (unpaginated) of search results, with 'result'
      appended and pluralized as necessary, e.g. "1 result" or "999 results".
    }
    tag 'results:count' do |tag|
      pluralize tag.locals.results.total_entries, 'result'
    end

    desc %{
      Returns the current page of search results.
    }
    tag 'results:current_page' do |tag|
      tag.locals.results.current_page
    end

    desc %{
      Returns the total number of pages of search results.
    }
    tag 'results:total_pages' do |tag|
      tag.locals.results.total_pages
    end

    desc %{
      Displays the original search term, sanitized for display.
    }
    tag 'results:query' do |tag|
      ActionController::Base.helpers.strip_tags tag.locals.query
    end

    desc %{
      Iterates over each search result. Sets @tag.locals.page@ to the current result.
    }
    tag 'results:each' do |tag|
      tag.locals.results.collect do |result|
        tag.locals.page = result
        tag.expand
      end.join("\n")
    end

    desc %{
      Returns the associated excerpt for each search result. Takes an optional
      @for@ attribute that can be set to @title@ or the name of a specific page
      part. If @for@ is omitted, the excerpt will be drawn from the concatenation
      of all page parts. If it is set to @title@ or the name of a part, the
      excerpted text will be limited to the page's title or the named part.
    }
    tag 'results:each:excerpt' do |tag|
      content = case tag.attr['for']
      when 'title' : tag.locals.page.title
      when nil : tag.locals.page.parts.map(&:content).join(' ')
      else tag.locals.page.part(tag.attr['for']).try(:content) || ''
      end
      tag.locals.results.excerpt_for(content, tag.locals.page.class)
    end

    desc %{
      Renders pagination for the results. Takes optional @class@, @previous_label@,
      @next_label@, @inner_window@, @outer_window@, and @separator@ attributes
      which will be forwarded to the WillPaginate link renderer.
    }
    tag 'results:pagination' do |tag|
      if tag.locals.results
        will_paginate(tag.locals.results, tag.locals.pagination_opts)
      end
    end

    desc %{
      Renders if no query parameter was passed. Useful for handling empty GETs
      to a search page.
    }
    tag 'results:unless_query' do |tag|
      tag.expand if tag.locals.query.blank?
    end

    desc %{
      Renders unless no query parameter was passed. Useful for handling empty GETs
      to a search page.
    }
    tag 'results:if_query' do |tag|
      tag.expand unless tag.locals.query.blank?
    end

    desc %{
      Renders if no results were returned.
    }
    tag 'results:if_empty' do |tag|
      tag.expand if tag.locals.results.empty?
    end

    desc %{
      Renders if no results were returned.
    }
    tag 'results:unless_empty' do |tag|
      tag.expand unless tag.locals.results.empty?
    end

    def will_paginate_options(tag)
      options = super
      options[:renderer] &&= SphinxSearch::LinkRenderer.new(tag.globals.page.url, tag.locals.query)
      options
    end

    def thinking_sphinx_options(tag)
      { :with => { :searchable => 1, :status_id => 100, :virtual => false }, :retry_stale => true }
    end
  end
end
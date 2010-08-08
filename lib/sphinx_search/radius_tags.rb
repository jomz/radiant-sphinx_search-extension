module SphinxSearch
  module RadiusTags
    include Radiant::Taggable
    include ActionView::Helpers::TextHelper

    desc %{
      Namespace for search tags.
    }
    tag 'search' do |tag|
      tag.locals.query = tag.globals.page.request[Radiant::Config['search.param_name'].to_sym]
      tag.expand
    end

    desc %{
      Renders a basic search form.
    }
    tag 'search:form' do |tag|
      form_id = tag.attr['id'] || 'search-form'
      form_class = tag.attr['class'] || 'search-form'
      form_value = tag.attr['value'] || 'Search'
      form_input = Radiant::Config['search.param_name'] || 'q'
      return <<-HTML
        <form action="#{tag.globals.page.url}" method="get" id="#{form_id}" class="#{form_class}">
          <input type="text" name="#{form_input}" value="#{tag.locals.query}">
          <input type="submit" value="#{form_value}">
        </form>
      HTML
    end

    desc %{
      Namespace for search results.
    }
    tag 'search:results' do |tag|
      options = thinking_sphinx_options(tag)
      paging = pagination_find_options(tag)
      if paging
        options.merge!(paging)
        tag.locals.pagination_opts = will_paginate_options(tag)
      end
      tag.globals.results ||= ThinkingSphinx.search(tag.locals.query, options)
      tag.expand if tag.globals.results.any? and not tag.locals.query.blank?
    end

    desc %{
      Renders if no results were returned.
    }
    tag 'search:no_results' do |tag|
      tag.expand if tag.globals.results.blank? and not tag.locals.query.blank?
    end

    desc %{
      Displays the total (unpaginated) number of search results, in the format
      *X results.* If you would like a different label than "result", pass
      the optional @label@ attribute. The label will be pluralized as necessary.
      
      *Usage:*
      
      <pre><code><r:search:results:count [label="..."] /></code></pre>
    }
    tag 'search:results:count' do |tag|
      label = tag.attr['label'] || 'result'
      pluralize tag.globals.results.total_entries, label
    end

    desc %{
      Returns the current page of search results.
    }
    tag 'search:results:current_page' do |tag|
      tag.globals.results.current_page
    end

    desc %{
      Returns the total number of pages of search results.
    }
    tag 'search:results:total_pages' do |tag|
      tag.globals.results.total_pages
    end

    desc %{
      Displays the original search term, sanitized for display.
    }
    tag 'search:query' do |tag|
      ActionController::Base.helpers.strip_tags tag.locals.query
    end

    desc %{
      Iterates over each search result. Sets @tag.locals.page@ to the current result.
    }
    tag 'search:results:each' do |tag|
      tag.globals.results.collect do |result|
        tag.locals.page = result
        tag.expand
      end.join("\n")
    end

    desc %{
      Returns the associated excerpt for each search result. If you want to
      take the excerpt from the page title or a specific page part, use the
      optional @for@ attribute.
      
      *Usage:*

      <pre><code><r:search:results:each:excerpt [for="title|part_name"]/></code></pre>
    }
    tag 'search:results:each:excerpt' do |tag|
      content = case tag.attr['for']
      when 'title' : tag.locals.page.title
      when nil : tag.locals.page.parts.map(&:content).join(' ')
      else tag.locals.page.part(tag.attr['for']).try(:content) || ''
      end
      tag.globals.results.excerpt_for(content, tag.locals.page.class)
    end

    desc %{
      Renders pagination for the results. Takes optional @class@, @previous_label@,
      @next_label@, @inner_window@, @outer_window@, and @separator@ attributes
      which will be forwarded to the WillPaginate link renderer.
    }
    tag 'search:results:pagination' do |tag|
      if tag.globals.results
        will_paginate(tag.globals.results, tag.locals.pagination_opts)
      end
    end

    desc %{
      Renders if no query parameter was passed. Useful for handling empty GETs
      to a search page.
    }
    tag 'search:empty_query' do |tag|
      tag.expand if tag.locals.query.try(:empty?)
    end

    def will_paginate_options(tag)
      options = super
      options[:renderer] &&= SphinxSearch::LinkRenderer.new(tag.globals.page.url, tag.locals.query)
      options
    end

    def thinking_sphinx_options(tag)
      { :with => { :status_id => 100, :virtual => false }, :retry_stale => true }
    end
  end
end
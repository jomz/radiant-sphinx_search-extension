module SphinxSearch
  module RadiusTags
    include Radiant::Taggable
    include ActionView::Helpers::TextHelper

    desc %{
      Namespace for all search tags.
    }
    tag 'search' do |tag|
      param = (SphinxSearch.param_name || 'q').to_sym
      tag.locals.query = tag.globals.page.request[param]
      tag.expand
    end

    desc %{
      Renders a basic search form. Takes optional @id@ and @class@ values if
      you need to target the form with specific CSS or JS; also takes an optional
      @button@ tag as the label on the input. If for some reason you don't want
      to use the default search term paramater @q@, you can override this by
      defining @SphinxSearch.param_name@ in @/config/initializers/sphinx_search.rb@.

      *Usage:*

      <pre><code><r:search:form [id="form-id"] [class="form-class"] [button="Go"] /></code></pre>
    }
    tag 'search:form' do |tag|
      form_id = tag.attr['id'] || 'search-form'
      form_class = tag.attr['class'] || 'search-form'
      form_value = tag.attr['button'] || I18n.translate('search')
      form_input = SphinxSearch.param_name || 'q'
      return <<-HTML
        <form action="#{tag.globals.page.url}" method="get" id="#{form_id}" class="#{form_class}">
          <input type="text" name="#{form_input}" value="#{tag.locals.query}">
          <input type="submit" value="#{form_value}">
        </form>
      HTML
    end

    desc %{
      Namespace for search results. Expands if a query was passed and at least
      one result was found. Takes a @paginated@ attribute and all the standard
      pagination attributes.

      Additional Thinking Sphinx options: @order@ and @sort_mode@ are passed
      directly to Sphinx. Valid orderable attributes are @created_at@,
      @updated_at@, @status_id@, @virtual@, and @title@. @sort_mode@ defaults
      to @asc@ (ascending); to reverse this, use @sort_mode="desc"@.

      *Usage:*

      <pre><code><r:search:results [paginated="false|true"] [per_page="..."] [order="..."] [sort_mode="ASC|DESC"] [...other pagination attributes]>...</r:search:results></code></pre>
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
      Expands if a query was run but no results were returned.
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
      count = tag.globals.results.total_entries
      if label = tag.attr['label']
        pluralize count, label
      else
        I18n.translate('result', :count => count)
      end
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

      *Usage:*

      <pre><code><r:search:results:each>...</r:search:results:each></code></pre>
    }
    tag 'search:results:each' do |tag|
      tag.globals.results.collect do |result|
        tag.locals.page = result
        tag.expand
      end.join("\n")
    end

    desc %{
      Returns the associated excerpt for each search result. If you want to
      take the excerpt from the page title or just one specific page part, use
      the optional @for@ attribute.
      
      *Usage:*

      <pre><code><r:search:results:each:excerpt [for="title|part_name"]/></code></pre>
    }
    tag 'search:results:each:excerpt' do |tag|
      content = case tag.attr['for']
      when 'title' then tag.locals.page.title
      when nil then tag.locals.page.parts.map(&:content).join(' ')
      else tag.locals.page.part(tag.attr['for']).try(:content) || ''
      end
      tag.globals.results.excerpt_for(content, tag.locals.page.class)
    end

    desc %{
      Renders pagination links for the results.

      *Usage:*
      <pre><code><r:search:results paginated="true" [pagination options]>...<r:search:results:pagination /></r:search:results></code></pre>
    }
    tag 'search:results:pagination' do |tag|
      if tag.globals.results
        will_paginate(tag.globals.results, tag.locals.pagination_opts)
      end
    end

    desc %{
      Renders if no a query was run without a term, e.g. someone hit the search
      button without entering anything.
    }
    tag 'search:empty_query' do |tag|
      tag.expand if tag.locals.query.try(:empty?)
    end

    private

      def will_paginate_options(tag)
        options = super
        options[:renderer] &&= SphinxSearch::LinkRenderer.new(tag.globals.page.url, tag.locals.query)
        options
      end

      def thinking_sphinx_options(tag)
        options = tag.attr.symbolize_keys.slice(:order, :sort_mode)
        [:order, :sort_mode].each { |attr| options[attr] &&= options[attr].to_sym }
        {
          :with => { :status_id => 100, :virtual => false },
          :without => { :class_crc => SphinxSearch.hidden_classes.map(&:to_crc32) },
          :retry_stale => true
        }.merge(options)
      end
  end
end
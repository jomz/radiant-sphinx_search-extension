module SphinxSearch
  module RadiusTags
    include Radiant::Taggable

    desc %{
      Opens the array of search results. Will not expand if no results are found.

      *Usage:*
      <pre><code><r:results>...</r:results></code></pre>
    }
    tag 'results' do |tag|
      if tag.globals.page.results.any?
        tag.locals.results = tag.globals.page.results
        tag.context.define_tag 'count', :for => tag.locals.results.total_entries
        tag.expand
      end
    end

    desc %{
      Iterates over each search result. Sets `tag.locals.page` to the current result.

      *Usage:*
      <pre><code><r:results:each>...</r:results:each></code></pre>
    }
    tag 'results:each' do |tag|
      tag.locals.results.collect do |result|
        tag.locals.page = result
        tag.expand
      end.join("\n")
    end

  end
end
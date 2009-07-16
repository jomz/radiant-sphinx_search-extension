module SphinxSearch
  module RadiusTags
    include Radiant::Taggable
    include ActionView::Helpers::TextHelper

    desc %{
      Opens the array of search results. Will not expand if no results are found.
    }
    tag 'results' do |tag|
      tag.locals.results = tag.globals.page.results
      tag.expand
    end

    desc %{
      Displays the total number (unpaginated) of search results, with 'result' appended and pluralized as necessary,
      e.g. "1 result" or "999 results".
    }
    tag 'results:count' do |tag|
      pluralize tag.locals.results.total_entries, 'result'
    end

    desc %{
      Displays the original search term, sanitized for display.
    }
    tag 'results:query' do |tag|
      ActionController::Base.helpers.strip_tags tag.globals.page.query
    end

    desc %{
      Iterates over each search result. Sets `tag.locals.page` to the current result.
    }
    tag 'results:each' do |tag|
      tag.locals.results.collect do |result|
        tag.locals.page = result
        tag.expand
      end.join("\n")
    end

  end
end
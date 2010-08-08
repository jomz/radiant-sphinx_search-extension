# The parameter passed in your search URLs.
SphinxSearch.param_name = 'q'

# Max length of content to index, per page. Bump this up if you have more than
# 8k of text per page (as calculated by combining all page parts.)
SphinxSearch.content_length = 8.kilobytes

# Don't include these page subclasses in the search results. This can also be
# accessed by declaring `self.searchable [true|false]` in your Page subclasses.
SphinxSearch.hidden_classes = %w(SearchPage JavascriptPage StylesheetPage)
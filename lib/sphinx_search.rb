module SphinxSearch
  mattr_accessor :param_name, :content_length, :hidden_classes
  self.param_name = 'q'
  self.content_length = 8.kilobytes
  self.hidden_classes = %w(SearchPage JavascriptPage StylesheetPage)
end
class SphinxSearchExtension < Radiant::Extension
  version "0.8.0"
  description "Search Pages with ThinkingSphinx"
  url "http://digitalpulp.com"
  
  def activate
    Page.send(:include, SphinxSearch::PageExtensions)
    PageContext.send(:include, SphinxSearch::PageContextExtensions)
    admin.page.edit.add :extended_metadata, "search_toggle"
    Radiant::Config["search.param_name"] ||= 'q'
  end
  
  def deactivate
  end
  
end
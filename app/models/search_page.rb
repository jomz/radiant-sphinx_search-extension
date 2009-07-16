class SearchPage < Page
  include SphinxSearch::RadiusTags
  attr_accessor :results

  def after_initialize
    @results = []
  end

  def cache?
    false
  end

  def process_with_search(request, response)
    @results = Page.search(request.params[:query], :conditions => { :searchable => 1 })
    process_without_search(request, response)
  end
  alias_method_chain :process, :search
end
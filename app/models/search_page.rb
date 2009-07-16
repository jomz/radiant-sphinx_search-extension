class SearchPage < Page
  include SphinxSearch::RadiusTags
  attr_accessor :results, :query

  def cache?
    false
  end

  def process_with_search(request, response)
    @query = request.params[:query]
    @results = Page.search(@query, :conditions => { :searchable => 1, :status_id => 100 })
    process_without_search(request, response)
  end
  alias_method_chain :process, :search
end
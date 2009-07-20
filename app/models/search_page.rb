class SearchPage < Page
  include SphinxSearch::RadiusTags
  include WillPaginate::ViewHelpers
  attr_accessor :results, :query

  @@per_page = 10

  def cache?
    false
  end

  def process(request, response)
    @request, @response = request, response

    @query = request.params[:query]
    @results = Page.search(@query, :conditions => { :searchable => 1, :status_id => 100 }, :page => request.params[:page], :per_page => @@per_page)

    super(request, response)
  end
end
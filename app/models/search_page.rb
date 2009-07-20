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

    # Validate only non-empty non-nil search terms
    unless @query.blank?
      @results = Page.search(@query, :conditions => { :searchable => 1, :status_id => 100 }, :page => request.params[:page], :per_page => @@per_page)
    else
      # Stub the expected collection object
      @results = ThinkingSphinx::Collection.new(0,@@per_page,0,0)
    end

    super(request, response)
  end
end
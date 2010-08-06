class SearchPage < Page
  include SphinxSearch::RadiusTags

  def cache?
    false
  end

end
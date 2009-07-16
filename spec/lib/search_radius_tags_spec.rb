require File.dirname(__FILE__) + '/../spec_helper'

describe SphinxSearch::RadiusTags do
  dataset :search_pages

  before do
    @page = pages(:search_results)
  end

  describe "results" do
    it "should expand if @page.results.any?" do
      @page.results = Page.search 'harmonious'
      @page.should render('<r:results>hi</r:results>').as('hi')
    end

    it "should not expand if no @page.results" do
      @page.results = Page.search 'bogus'
      @page.should render('<r:results>hi</r:results>').as('')
    end
  end

  describe "results:each" do
    it "should iterate over results" do
      @page.results = Page.search 'harmonious', :conditions => { :searchable => 1 }
      @page.should render('<r:results:each><r:title /></r:results:each>').as("searchable")
    end
  end

  describe "results:count" do
    it "should return full count" do
      @page.results = Page.search 'harmonious'
      @page.should render('<r:results:count />').as(@page.results.total_entries.to_s)
    end
  end
end
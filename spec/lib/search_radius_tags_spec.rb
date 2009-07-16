require File.dirname(__FILE__) + '/../spec_helper'

describe SphinxSearch::RadiusTags do
  dataset :search_pages

  before do
    @page = pages(:search_results)
  end

  describe "results" do
    it "should expand" do
      @page.results = Page.search 'harmonious'
      @page.should render('<r:results>hi</r:results>').as('hi')
    end
  end

  describe "results:each" do
    it "should iterate over results" do
      @page.results = Page.search 'harmonious', :conditions => { :searchable => 1 }
      @page.should render('<r:results:each><r:title /></r:results:each>').as("searchable")
    end

    it "should not expand if no results" do
      @page.results = []
      @page.should render('<r:results:each><r:title /></r:results:each>').as('')
    end
  end

  describe "results:count" do
    it "should return full count" do
      @page.results = Page.search 'harmonious'
      @page.should render('<r:results:count />').as("#{@page.results.total_entries} results")
    end

    it "should be zero if no results" do
      @page.results = Page.search 'bogus'
      @page.should render('<r:results:count/>').as('0 results')
    end
  end

  describe "results:query" do
    it "should sanitize query" do
      @page.query = '<script>query'
      @page.should render('<r:results:query/>').as('query')
    end
  end
end
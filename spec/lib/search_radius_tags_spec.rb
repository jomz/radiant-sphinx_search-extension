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

  describe "results:each:excerpt" do
    it "should return excerpt from concatenated parts content if no `for` attr is passed" do
      @page.results = Page.search 'harmonious'
      @page.should render('<r:results:each><r:excerpt /></r:results:each>').matching %r{<span class="match">harmonious</span>}
    end

    it "should return excerpt from page title if `for` attr = title" do
      @page.results = Page.search pages(:searchable).title
      @page.should render('<r:results:each><r:excerpt for="title"/></r:results:each>').matching %r{<span class="match">#{pages(:searchable).title}</span>}
    end

    it "should return excerpt from named part if `for` specifies a part" do
      @page.results = Page.search 'harmonious'
      output = @page.send :parse, '<r:results:each><r:excerpt for="extended"/></r:results:each>'
      output.should match(%r{<span class="match">harmonious</span>})
      output.should_not match(%r{Hello world!})
    end

    it "should return nothing if named part does not exist" do
      @page.results = Page.search 'harmonious'
      output = @page.send :parse, '<r:results:each><r:excerpt for="bogus"/></r:results:each>'
      output.should be_blank
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

  describe "results:current_page" do
    it "should display current page of results" do
      @page.results = Page.search 'harmonious'
      @page.should render('<r:results:current_page/>').as('1')
    end
  end

  describe "results:total_pages" do
    it "should return total # of pages" do
      @page.results = Page.search 'harmonious'
      @page.should render('<r:results:total_pages/>').as('1')
    end
  end

  describe "results:query" do
    it "should sanitize query" do
      @page.query = '<script>query'
      @page.should render('<r:results:query/>').as('query')
    end
  end

  describe "results:unless_query" do
    it "should render if query was blank" do
      @page.query = nil
      @page.should render('<r:results:unless_query>enter query</r:results:unless_query>').as('enter query')
    end

    it "should not render if query is present" do
      @page.query = 'harmonious'
      @page.should render('<r:results:unless_query>please enter query</r:results:unless_query>').as('')
    end
  end

  describe "results:if_empty" do
    it "should render if results were blank" do
      @page.results = Page.search 'bogus'
      @page.should render('<r:results:if_empty>try again</r:results:if_empty>').as('try again')
    end

    it "should not render if any results" do
      @page.results = Page.search 'harmonious'
      @page.should render('<r:results:if_empty>try again</r:results:if_empty>').as('')
    end
  end
end
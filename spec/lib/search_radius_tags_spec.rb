require File.dirname(__FILE__) + '/../spec_helper'

class Array
  alias_method :total_entries, :size # make arrays quack like TS result sets
end

describe SphinxSearch::RadiusTags do
  dataset :search_pages

  before do
    @page = pages(:search_results)
    @request = ActionController::TestRequest.new
    @request.params[:q] = 'query'
    ActionController::TestRequest.stub!(:new).and_return(@request)
    ThinkingSphinx.stub!(:search).and_return([pages(:searchable)])
  end

  describe 'r:search:form' do
    it "should render a form input" do
      form = @page.should render('<r:search:form id="test" class="test" value="go" />').matching(/action="#{@page.url}"/)
    end
  end

  describe "r:search:results" do
    it "should expand if there are results" do
      @page.should render('<r:search:results>hi</r:search:results>').as('hi')
    end

    it "should not expand if no query was run" do
      @request.params[:q] = ''
      @page.should render('<r:search:results>hi</r:search:results>').as('')
    end
  end

  describe "r:search:results:each" do
    it "should iterate over results" do
      @page.should render('<r:search:results:each><r:title /></r:search:results:each>').as(pages(:searchable).title)
    end
  end

  describe "r:search:results:count" do
    it "should return result count" do
      @page.should render('<r:search:results:count />').as("1 result")
    end

    it "should pluralize any label" do
      ThinkingSphinx.stub!(:search).and_return([pages(:searchable), pages(:search_results)])
      @page.should render('<r:search:results:count label="item" />').as("2 items")
    end
  end

  describe "r:search:query" do
    it "should sanitize query" do
      @request.params[:q] = '<script>query'
      @page.should render('<r:search:query />').as('query')
    end
  end

  describe "r:search:empty_query" do
    it "should render if query was blank" do
      @request.params[:q] = ''
      @page.should render('<r:search:empty_query>empty</r:search:empty_query>').as('empty')
    end
  
  end

  describe "r:search:no_results" do
    it "should render if results were empty" do
      ThinkingSphinx.stub!(:search).and_return([])
      @page.should render('<r:search:no_results>none</r:search:no_results>').as('none')
    end
  end
end
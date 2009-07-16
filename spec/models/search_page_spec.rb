require File.dirname(__FILE__) + '/../spec_helper'

describe SearchPage do
  dataset :search_pages

  before do
    @page = SearchPage.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
  end

  it "should have a results array" do
    @page.results.should == []
  end

  it "should search Pages with query" do
    @request.query_parameters = {:query => 'harmonious'}
    @page.process(@request, @response)
    @page.results.should include pages(:searchable)
  end

  it "should omit pages marked as unsearchable" do
    @request.query_parameters = {:query => 'harmonious'}
    @page.process(@request, @response)
    @page.results.should_not include pages(:unsearchable)
  end
end
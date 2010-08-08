require File.dirname(__FILE__) + '/../spec_helper'

describe Page do
  describe "Page.searchable" do
    it "should add itself to the hidden classes array" do
      SphinxSearch.hidden_classes = []
      FileNotFoundPage.searchable false
      SphinxSearch.hidden_classes.should include('FileNotFoundPage')
    end

    it "should remove itself from the hidden classes array" do
      SphinxSearch.hidden_classes = %w(FileNotFoundPage)
      FileNotFoundPage.searchable true
      SphinxSearch.hidden_classes.should_not include("FileNotFoundPage")
    end
  end

  describe "#thinking_sphinx_options" do
    it "should description" do
      SphinxSearch.hidden_classes = %w(FileNotFoundPage)
      opts = SearchPage.new.send :thinking_sphinx_options, nil
      opts[:without][:class_crc].should include('FileNotFoundPage'.to_crc32)
    end
  end
end
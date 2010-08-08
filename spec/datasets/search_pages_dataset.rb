class SearchPagesDataset < Dataset::Base
  uses :home_page

  def load
    create_page 'searchable', :slug => 'searchable', :parent_id => page_id(:home),
                :description => 'a searchable page' do
      create_page_part "body", :content => "Hello world!", :id => 1
      create_page_part "extended", :content => "sweet harmonious biscuits", :id => 2
    end

    create_page 'search_results', :slug => 'search_results', :parent_id => page_id(:home), :class_name => "SearchPage"
  end
end
class SearchPagesDataset < Dataset::Base
  uses :home_page

  def load
    create_page 'searchable', :slug => '/searchable', :parent_id => page_id(:home),
                :description => 'a searchable page', :searchable => 1 do
      create_page_part "body", :content => "Hello world!", :id => 1
      create_page_part "extended", :content => "sweet harmonious biscuits", :id => 2
    end

    create_page 'unsearchable', :slug => '/unsearchable', :parent_id => page_id(:home),
                :description => 'an unsearchable page', :searchable => 0 do
      create_page_part "body", :content => "Hello world!", :id => 3
      create_page_part "extended", :content => "sweet harmonious biscuits", :id => 4
    end
  end
end
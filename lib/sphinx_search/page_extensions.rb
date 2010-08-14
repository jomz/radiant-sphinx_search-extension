require 'thinking_sphinx'

module SphinxSearch
  module PageExtensions
   
   def self.included(base)
     base.define_index do
       set_property :delta => true, :group_concat_max_len => SphinxSearch.content_length || 8.kilobytes
       set_property :field_weights => { 'title' => 100 }
       indexes title, :sortable => true
       indexes parts.content
       has created_at, updated_at, status_id, virtual
     end

     base.extend ClassMethods
   end

   module ClassMethods
     def searchable(search=true)
       search ? SphinxSearch.hidden_classes.delete(self.name) : SphinxSearch.hidden_classes.push(self.name)
     end
   end

   end
end
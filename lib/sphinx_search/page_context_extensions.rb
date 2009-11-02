module SphinxSearch
  module PageContextExtensions
    def self.included(base)
      base.alias_method_chain :set_process_variables, :sphinx
    end

    def set_process_variables_with_sphinx(result)
      quacks_like_page = lambda do |object|
        [:request, :response, :request=, :response=].all? { |method| object.respond_to?(method) }
      end
      set_process_variables_without_sphinx(result) if quacks_like_page.call(result)
    end
    private :set_process_variables_with_sphinx

  end
end
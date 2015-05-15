module Taxplorer
  module View

    def table_view(node)
      if node[:details]
        puts Hirb::Helpers::AutoTable.render(info[:details])
      else
        puts "no information"
      end
    end

    def section_tree(query)
      @current_section = @records["sections"].find {|s| s[:name] == query}
      @current_section[:elements].select {|e| e[:parent] == nil}.map do |node|
        [node[:label], child_tree(node)]
      end
    end

    def child_tree(node)
      @current_section[:elements].select {|e| e[:parent] == node[:label]}.map do |child|
        [child[:label], child_tree(child)]
      end
    end
  end
end

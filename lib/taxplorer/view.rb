module Taxplorer
  module View

    def table_view(node)
      if node[:details]
        puts Hirb::Helpers::AutoTable.render(info[:details])
      else
        puts "no information"
      end
    end

    def tree_view(node, links="")
      children = @section[:elements].values.select {|e| e[:parent] == node}
      puts links + node
      links = links + "  "
      children.map do |child|
        tree_view(child[:label], links)
      end
    end
  end
end



module Taxplorer
  module View

    def initialize
      @nodes = []
    end

    def build_tree(node, level)
      leaf = {value: node, level: level}
      @nodes << leaf
      children = @section[:elements].values.select {|e| e[:parent] == node}
      level += 1
      children.map do |child|
        build_tree(child[:label], level)
      end
      @nodes
    end

    def tree_view(node)
      build_tree(node, 0)
      Hirb::Helpers::Tree.render(@nodes, type: :directory)
    end
  end
end



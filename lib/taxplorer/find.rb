module Taxplorer
  module Find

    def get_sections
      @records["sections"].map {|s| s[:name]}
    end

    def get_section(section_name)
      @section = @records["sections"].find {|s| s[:name] == section_name}
      @section[:elements].values.select {|e| e.parent == nil}
    end

    def get_info(node_label)
      info = @records["elements"].find {|s| s[:id] == node_label}
      puts Hirb::Helpers::AutoTable.render(info[:details])
      node_commands(node_label)
    end

    def get_parent(node)
      child = @section[:elements].values.find {|e| e[:label] == node}
      parent = @section[:elements].values.find {|p| p[:label] == child[:parent]} if child
      parent ? node_commands(parent[:label]) : menu_prompt
    end

    def get_children(node_id)
      node = @section[:elements].values.find {|e| e[:label] == node_id}
      nodes = @section[:elements].values.select {|e| e[:parent] == node_id}
      if nodes.any?
        child_nodes_prompt(nodes)
      else
        puts "no children"
        node_commands(node_id)
      end
    end
  end
end

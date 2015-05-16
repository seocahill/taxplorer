module Taxplorer
  module Command

    def load_shell
      loop do
        welcome_prompt
        break if @run == false
      end
      puts "bye bye"
    end

    def welcome_prompt
      choose do |menu|
        menu.prompt = "Choose preferred taxonomy"
        ["Uk GAAP", "UK IFRS"].each do |t|
          menu.choice(t) { |c| say("have a glass of whiskey while we load up #{c} for you"); load_taxonomy }
        end
      end
    end

    def menu_prompt
      clear
      choose do |menu|
        menu.prompt = "Choose Taxonomy section"
        get_sections.each do |s|
          menu.choice(s) { |s| section_prompt(s)}
        end
      end
    end

    def section_prompt(section_name)
      clear
      choose do |menu|
        menu.prompt = "Choose Heading"
        get_section(section_name).each do |s|
          menu.choice(s[:label]) { |s| node_commands(s)}
        end
      end
    end

    def child_nodes_prompt(nodes)
      choose do |menu|
        menu.prompt = "Select node"
        nodes.each do |s|
          menu.choice(s[:label]) { |s| node_commands(s)}
        end
      end
    end

    def node_commands(node)
      puts "Viewing #{node}"
      cmd = ask("Enter command:  ", %w{info children parent menu tree quit}) {|q| q.readline = true}
      case cmd
      when "info"
        get_info(node)
      when "children"
        get_children(node)
      when "parent"
        get_parent(node)
      when "menu"
        menu_prompt
      when "tree"
        clear
        tree_view(node)
        puts "\n\n"
        node_commands(node)
      when "quit"
        quit
      end
    end

    def quit
      @run = false
    end

    def clear
      system "clear" or system "cls"
    end
  end
end

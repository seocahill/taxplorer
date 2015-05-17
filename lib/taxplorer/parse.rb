module Taxplorer
  module Parse

    Node = Struct.new(:label, :parent, :copies)

    @pinwheel = %w{ | / - \\ }

    def load_taxonomy
      parse_taxonomy_files
      parse_presentation_files
      menu_prompt
    end

    private

    def parse_taxonomy_files
      Dir.glob("data/taxonomies/uk-gaap/**/*.xsd") do |file|
        parsed_file = Nokogiri::XML(File.open(file))
        add_sections(parsed_file)
        add_elements(parsed_file)
      end
    end

    def parse_presentation_files
      Dir.glob("data/taxonomies/uk-gaap/presentation**/*.xml") do |file|
        create_tree(Nokogiri::XML(File.open(file)))
      end
    end

    def add_sections(parsed_file)
      roles = parsed_file.xpath("//link:roleType")
      roles.each_with_index do |role, index|
        if role.xpath("link:usedOn").text == "link:presentationLink"
          @records["sections"] << {name: role.xpath("link:definition").text, role_uri: role.attributes["roleURI"].value, elements: Hash.new}
        end
      end
    end

    def add_elements(parsed_file)
      elements = parsed_file.search("element")
      elements.each_with_index do |element, i|
        id = element.attributes["id"] ? element.attributes["id"].value : nil
        @records["elements"] << {id: id, details: add_details(element)}
        STDOUT.write "\rAdding elements #{percentage(i, elements)}% " + @pinwheel.rotate!.first
      end
    end

    def create_tree(parsed_file)
      parsed_file.search('presentationLink').each do |p_link|
        section = @records["sections"].find {|s| s[:role_uri] == p_link.attributes["role"].value}
        add_nodes(section, p_link) if section
      end
    end

    def add_nodes(section, p_link)
      nodes = p_link.search('loc, presentationArc')
      nodes.each_with_index do |node, i|
        if node.name == "loc"
          create_node(section[:elements], node)
        elsif node.name == "presentationArc"
          upsert_node(section[:elements], node)
        end
        STDOUT.write "\rBuilding #{p_link.attributes["role"].value} tree #{percentage(i, nodes)}% " + @pinwheel.rotate!.first
      end
      clear
    end

    def add_details(element)
      info = {}
      element.attributes.each do |key, value|
        info[key] = value.value
      end
      info
    end

    def create_node(elements, loc)
      node = Node.new(loc.attributes["label"].value, nil, 1)
      elements[node.label] ||= node
    end

    def upsert_node(elements, arc)
      node = elements[arc.attributes["to"].value]
      if node and node.parent
        node.copies += 1
        elements[node.label + "-#{node.copies}"] = Node.new(arc.attributes["to"].value, arc.attributes["from"].value)
      else
        node.parent = arc.attributes["from"].value
      end
    end

    def percentage(index, elements)
      (index.to_f / elements.length * 100).to_i
    end
  end
end

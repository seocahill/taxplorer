
require 'test_helper'
require 'taxplorer'

class TestView < Minitest::Test
  def setup
    @section = {
      elements: {
        "root": {label: "root"},
        "A": {label: "A", parent: "root"},
        "B": {label: "B", parent: "root"},
        "C": {label: "C", parent: "root"},
        "D": {label: "D", parent: "B"},
        "E": {label: "E", parent: "D"},
        "F": {label: "F", parent: "D"}
      }
    }
  end

  def tree_view(node, links="")
    children = @section[:elements].values.select {|e| e[:parent] == node}
    puts links + node
    links = links + "  "
    children.map do |child|
      tree_view(child[:label], links)
    end
  end

  def test_tree_view
    result = "
      root
      |_A
      |_B
      | |_D
      |   |_E
      |   |_F
      |_C
    "
    assert_equal result, tree_view("root")
  end
end

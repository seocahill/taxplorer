
require 'test_helper'
require 'taxplorer'

class TestView < Minitest::Test
  def setup
    @mockapp = Class.new do
      include Taxplorer::View
      def initialize
        @nodes = []
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
      def clear;end
    end.new
  end

  def test_build_tree
    tree_hash = [
      {value: "root", level:0},
      {value: "A", level:1},
      {value: "B", level:1},
      {value: "D", level:2},
      {value: "E", level:3},
      {value: "F", level:3},
      {value: "C", level:1},
    ]
    assert_equal tree_hash, @mockapp.build_tree("root", 0)
  end

  def test_tree_view
    result =
      "root\n"+
      "|-- A\n"+
      "|-- B\n"+
      "|   `-- D\n"+
      "|       |-- E\n"+
      "|       `-- F\n"+
      "`-- C"
    assert_equal result, @mockapp.tree_view("root")
  end
end

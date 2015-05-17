require 'test_helper'
require 'taxplorer'

class TestFind < Minitest::Test
  @@taxonomy_file = Nokogiri::XML(File.open('data/taxonomies/uk-gaap/xsds/uk-aurep-2009-09-01.xsd'))
  @@presentation_file = Nokogiri::XML(File.open('data/taxonomies/uk-gaap/presentation/uk-aurep-2009-09-01-presentation.xml'))

  def setup
    @mockapp = Class.new do
      include Taxplorer::Parse
      include Taxplorer::Find
      attr_reader :records
      def initialize;@records = {"sections" => [], "elements" => []};end
      def clear;end
      def node_commands(node);"command";end
      def menu_prompt;"menu";end
      def child_nodes_prompt(nodes);"child_prompt";end
    end.new
    @mockapp.send(:add_sections, @@taxonomy_file)
    @mockapp.send(:add_elements, @@taxonomy_file)
    @mockapp.send(:create_tree, @@presentation_file)
  end

  def test_get_sections
    assert_equal @mockapp.get_sections, ["06 - Auditor's Report"]
  end

  def test_get_section
    section = @mockapp.get_section("06 - Auditor's Report")
    assert_equal section.length, 3
    assert_equal section.first[:label], "uk-aurep_AuditorInformationHeading"
  end

  def test_get_parent
    @mockapp.get_section("06 - Auditor's Report")
    assert_equal @mockapp.get_parent("uk-aurep_DateAuditorsReport"), "command"
    assert_equal @mockapp.get_parent("uk-aurep_AuditorInformationHeading"), "menu"
  end

  # def test_get_children
  #   @mockapp.get_section("06 - Auditor's Report")
  #   assert_equal @mockapp.get_parent("uk-aurep_DateAuditorsReport"), "command"
  #   assert_equal @mockapp.get_parent("uk-aurep_AuditorInformationHeading"), "menu"
  # end

end

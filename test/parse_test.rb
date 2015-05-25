require 'test_helper'
require 'taxplorer'

class TestParse < Minitest::Test
  @@taxonomy_file = Nokogiri::XML(File.open(Gem.datadir('taxplorer') + '/taxonomies/uk-gaap/xsds/uk-aurep-2009-09-01.xsd'))
  @@presentation_file = Nokogiri::XML(File.open(Gem.datadir('taxplorer') + '/taxonomies/uk-gaap/presentation/uk-aurep-2009-09-01-presentation.xml'))

  def setup
    @mockapp = Class.new do
      include Taxplorer::Parse
      attr_reader :records
      def initialize;@records = {"sections" => [], "elements" => []};end
      def clear;end
    end.new
  end

  def test_sections_are_added
    aurep_section = {:name=>"06 - Auditor's Report", :role_uri=>"http://www.xbrl.org/uk/role/AuditorsReport", :elements=>{}}
    @mockapp.send(:add_sections, @@taxonomy_file)
    assert_includes @mockapp.records["sections"], aurep_section
  end

  def test_elements_are_added
    @mockapp.send(:add_elements, @@taxonomy_file)
    assert_equal @mockapp.records["elements"].count, 55
    assert_equal @mockapp.records["elements"].first[:id], "uk-aurep_AuditFeesExpenses"
  end

  def test_element_details_are_added
    @mockapp.send(:add_elements, @@taxonomy_file)
    info = @mockapp.records["elements"].first[:details]
    assert_equal info.keys, ["id", "name", "type", "substitutionGroup", "periodType", "balance", "nillable"]
    assert_equal info["type"], "xbrli:monetaryItemType"
    assert_equal info["balance"], "debit"
  end

  def test_tree_creation
    @mockapp.send(:add_sections, @@taxonomy_file)
    @mockapp.send(:create_tree, @@presentation_file)
    nodes = @mockapp.records["sections"].first[:elements]
    roots = nodes.values.reject {|n| n.parent}
    assert_equal roots.length, 3, "the auditors report should have three root nodes"
    assert_equal nodes.values.select {|n| n.parent == "uk-aurep_AuditorInformationHeading"}.count, 7, "the auditors information root should have three chilren"
    assert_equal nodes["uk-aurep_OtherNon-auditServicesEntitySubsidiariesFees"].parent, "uk-aurep_OtherNon-auditServicesFees", "deep node not added to tree"
  end
end

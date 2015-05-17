require 'test_helper'
require 'taxplorer'

class TestView < Minitest::Test
  @@taxonomy_file = Nokogiri::XML(File.open('data/taxonomies/uk-gaap/xsds/uk-aurep-2009-09-01.xsd'))
  @@presentation_file = Nokogiri::XML(File.open('data/taxonomies/uk-gaap/presentation/uk-aurep-2009-09-01-presentation.xml'))

  def setup
    @mockapp = Class.new do
      include Taxplorer::Parse
      include Taxplorer::View
      include Taxplorer::Find
      attr_reader :records
      def initialize;@records = {"sections" => [], "elements" => []};end
      def clear;end
    end.new
    @mockapp.send(:add_sections, @@taxonomy_file)
    @mockapp.send(:add_elements, @@taxonomy_file)
    @mockapp.send(:create_tree, @@presentation_file)
  end

  def test_tree_view
    @mockapp.get_section("06 - Auditor's Report")
    l_1 = /uk-aurep_AuditorInformationHeading/
    l_2 = /uk-bus_DescriptionOrOtherInformationOnThirdPartyAgent/
    l_3 = /uk-bus_EntityAccountantsOrAuditors/
    l_4 = /uk-bus_TotalAgentsDefault/
    l_5 = /uk-bus_JointAgent3/
    matches = Regexp.union(l_1, l_2, l_3, l_4, l_5)
    assert_output(matches){ @mockapp.tree_view("uk-aurep_AuditorInformationHeading") }
  end
end

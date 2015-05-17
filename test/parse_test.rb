require 'test_helper'
require 'taxplorer'

class TestParse < Minitest::Test
  @@taxonomy_file = Nokogiri::XML(File.open('data/taxonomies/uk-gaap/xsds/uk-aurep-2009-09-01.xsd'))
  @@presentation_file = Nokogiri::XML(File.open('data/taxonomies/uk-gaap/presentation/uk-aurep-2009-09-01-presentation.xml'))

  def setup
    @mockapp = Class.new do
      include Taxplorer::Parse
      attr_reader :records
      def initialize;@records = {"sections" => [], "elements" => []};end
    end.new
  end

  def test_sections_are_added
    aurep_section = {:name=>"06 - Auditor's Report", :role_uri=>"http://www.xbrl.org/uk/role/AuditorsReport", :elements=>{}}
    @mockapp.send(:add_sections, @@taxonomy_file)
    assert_includes @mockapp.records["sections"], aurep_section
  end

  def test_elements_are_added
    @mockapp.send(:add_elements, @@taxonomy_file)
    assert_equal @mockapp.records["elements"], 63
  end
end

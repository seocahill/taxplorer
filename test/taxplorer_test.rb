require 'test_helper'
require 'taxplorer'

class TestTaxplorer < Minitest::Test
  # def setup
  #   @app = Taxplorer.new
  # end

  def test_welcome_prompt
    Dir.glob("data/taxonomies/uk-gaap/**/*.xsd") do |file|
        puts file
    end
  end
end

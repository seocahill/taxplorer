require 'test_helper'
require 'taxplorer'

class TestTaxplorer < Minitest::Test
  def setup
    @app = Taxplorer.new
  end

  def test_welcome_prompt
    puts @app.welcome_prompt
    assert_equal "Choose preferred taxonomy", @app.welcome_prompt
  end
end

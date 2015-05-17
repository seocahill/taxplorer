require 'test_helper'
require 'taxplorer'

class TestTaxplorer < Minitest::Test

  module Taxplorer::Command
    def load_shell
      return true
    end
  end

  def test_app_initialization
    app = Application.new
    assert_equal [], app.records["sections"]
    assert_equal [], app.records["elements"]
    assert app.run
    assert_send [app, :load_shell], "didn't load the shell"
  end
end

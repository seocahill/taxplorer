require 'simplecov'
SimpleCov.start do
  add_filter "test"
end
require "codeclimate-test-reporter"
CodeClimate::TestReporter.start
require 'minitest/autorun'


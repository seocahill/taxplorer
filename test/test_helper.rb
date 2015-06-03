require 'simplecov'
require "codeclimate-test-reporter"
SimpleCov.start do
  add_filter "test"
  add_filter "taxplorer/command.rb"
end
CodeClimate::TestReporter.start
require 'minitest/autorun'

module Helpers
  def with_stdin
    stdin = $stdin
    $stdin, write = IO.pipe
    yield write
  ensure
    write.close
    $stdin = stdin
  end
end

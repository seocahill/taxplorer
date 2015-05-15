#!/usr/bin/env ruby

require "nokogiri"
require "taxplorer/command"
require "taxplorer/parse"
require "taxplorer/find"
require "taxplorer/view"
require 'hirb'
require 'highline/import'

class Application
  include Taxplorer::Command
  include Taxplorer::Parse
  include Taxplorer::Find
  include Taxplorer::View

  attr_reader :records, :run

  def initialize
    @records ||= Hash.new
    @records["sections"] ||= []
    @records["elements"] ||= []
    @run = true
    @pinwheel = %w{ | / - \\ }
    load_shell
  end
end




require "opal"
require "opal/browser"
require "clearwater/component"
require 'clearwater/link'
require 'clearwater/router'

module Clearwater
  require_relative "clearwater/version"
end

%w(opal shared).each do |dir|
  Opal.append_path(File.expand_path(File.join("..", "..", dir), __FILE__).untaint)
end

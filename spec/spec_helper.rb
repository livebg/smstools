lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'minitest/spec'
require 'minitest/ansi'
require 'minitest/autorun'

MiniTest::ANSI.use!

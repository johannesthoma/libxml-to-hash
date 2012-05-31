# TODO: Port this test to something that can be tested standalone
# (that is without rails).
# require 'rails'
require "test/unit"
require "./lib/libxml_to_hash.rb"

class FromXmlTest < Test::Unit::TestCase
  def test_tiss_xml_node_class
    assert_equal "karin", LibXmlNode.new("karin", "zak").content
    assert_equal "zak", LibXmlNode.new("karin", "zak").attributes
  end

  def test_from_xml
    assert_equal({:karin => {} }, Hash.from_xml("<karin/>"))
    assert_equal({:karin => {} }, Hash.from_xml("<karin></karin>"))
    assert_equal({:karin => "zak" }, Hash.from_xml("<karin>zak</karin>"))
    assert_equal({:karin => LibXmlNode.new({}, {:zak => "lebt"})}, Hash.from_xml("<karin zak=\"lebt\"></karin>"))
    assert_equal({:karin => LibXmlNode.new({:zak => "lebt" }, {})}, Hash.from_xml("<karin><zak>lebt</zak></karin>"))
    assert_equal({:karin => LibXmlNode.new({:zak => "nicht"}, {:zak => "lebt"})}, Hash.from_xml("<karin zak=\"lebt\"><zak>nicht</zak></karin>"))
    assert_equal({:karin => {:zak => ["nicht", "schon"] }}, Hash.from_xml("<karin><zak>nicht</zak><zak>schon</zak></karin>"))
    assert_equal({:karin => LibXmlNode.new({:zak => "nicht", :lebt => "schon"}, {})}, Hash.from_xml("<karin><zak>nicht</zak><lebt>schon</lebt></karin>"))
    assert_equal({:karin => LibXmlNode.new({:zak => "nicht", :lebt => "schon", :oder => LibXmlNode.new({:was => "nicht" }, {})})}, Hash.from_xml("<karin><zak>nicht</zak><lebt>schon</lebt><oder><was>nicht</was></oder></karin>"))
    assert_equal({:karin => LibXmlNode.new("schon", {:zak => "lebt"})}, Hash.from_xml("<karin zak=\"lebt\">schon</karin>"))
    assert_nothing_raised { Hash.from_xml("<karin") }
    assert_nil Hash.from_xml("<karin")
  end
end

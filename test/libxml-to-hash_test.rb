# -*- encoding : utf-8 -*-
require "test/unit"
require "./lib/libxml_to_hash.rb"

class LibXmlToHashTest < Test::Unit::TestCase
  def test_tiss_xml_node_class
    assert_equal "karin", LibXmlNode.new("karin", "zak").content
    assert_equal "zak", LibXmlNode.new("karin", "zak").attributes
  end

  def test_from_libxml
    assert_equal({"karin" => LibXmlNode.new({},{})}, Hash.from_libxml("<karin/>"))
    assert_equal({"karin" => LibXmlNode.new({},{})}, Hash.from_libxml("<karin></karin>"))
    assert_equal({"karin" => "zak"}, Hash.from_libxml("<karin>zak</karin>"))
    assert_equal({"karin" => LibXmlNode.new({}, {"zak" => "lebt"})}, Hash.from_libxml("<karin zak=\"lebt\"></karin>"))
    assert_equal({"karin" => LibXmlNode.new({"zak" => "lebt"}, {})}, Hash.from_libxml("<karin><zak>lebt</zak></karin>"))
    assert_equal({"karin" => LibXmlNode.new({"zak" => "nicht"}, {"zak" => "lebt"})}, Hash.from_libxml("<karin zak=\"lebt\"><zak>nicht</zak></karin>"))
    assert_equal({"karin" => {"zak" => ["nicht", "schon"] }}, Hash.from_libxml("<karin><zak>nicht</zak><zak>schon</zak></karin>"))
    assert_equal({"karin" => LibXmlNode.new({"zak" => "nicht", "lebt" => "schon"}, {})}, Hash.from_libxml("<karin><zak>nicht</zak><lebt>schon</lebt></karin>"))
    assert_equal({"karin" => LibXmlNode.new({"zak" => "nicht", "lebt" => "schon", "oder" => LibXmlNode.new({"was" => "nicht" }, {})})}, Hash.from_libxml("<karin><zak>nicht</zak><lebt>schon</lebt><oder><was>nicht</was></oder></karin>"))
    assert_equal({"karin" => LibXmlNode.new("schon", {"zak" => "lebt"})}, Hash.from_libxml("<karin zak=\"lebt\">schon</karin>"))
    assert_equal({"karin" => LibXmlNode.new({"zak"=>"textmoretext"}, Hash.from_libxml("<karin>text<zak/>moretext</karin>"))
    assert_nothing_raised { Hash.from_libxml("<karin") }
    assert_nil Hash.from_libxml("<karin")
  end
end

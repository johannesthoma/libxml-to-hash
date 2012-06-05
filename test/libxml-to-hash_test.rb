# -*- encoding : utf-8 -*-
require "test/unit"
require "./lib/libxml_to_hash.rb"

class LibXmlToHashTest < Test::Unit::TestCase
  def test_tiss_xml_node_class
    assert_equal "karin", LibXmlNode.create("karin", "zak", "lebt").subnodes
    assert_equal "zak", LibXmlNode.create("karin", "zak", "lebt").attributes
    assert_equal "lebt", LibXmlNode.create("karin", "zak", "lebt").text
  end

  def test_from_libxml
    assert_equal({"karin" => {}}, Hash.from_libxml("<karin/>"))
    assert_equal({"karin" => {}}, Hash.from_libxml("<karin></karin>"))
    assert_equal({"karin" => "zak"}, Hash.from_libxml("<karin>zak</karin>"))
    assert_equal({"karin" => LibXmlNode.create({}, {"zak" => "lebt"}, "")}, Hash.from_libxml("<karin zak=\"lebt\"></karin>"))
    assert_equal({"karin" => {"zak" => "lebt"}}, Hash.from_libxml("<karin><zak>lebt</zak></karin>"))
    assert_equal({"karin" => LibXmlNode.create({"zak" => "nicht"}, {"zak" => "lebt"}, "")}, Hash.from_libxml("<karin zak=\"lebt\"><zak>nicht</zak></karin>"))
    assert_equal({"karin" => {"zak" => ["nicht", "schon"] }}, Hash.from_libxml("<karin><zak>nicht</zak><zak>schon</zak></karin>"))
    assert_equal({"karin" => {"zak" => "nicht", "lebt" => "schon"}}, Hash.from_libxml("<karin><zak>nicht</zak><lebt>schon</lebt></karin>"))
    assert_equal({"karin" => {"zak" => "nicht", "lebt" => "schon", "oder" => {"was" => "nicht" }}}, Hash.from_libxml("<karin><zak>nicht</zak><lebt>schon</lebt><oder><was>nicht</was></oder></karin>"))
    assert_equal({"karin" => LibXmlNode.create({}, {"zak" => "lebt"}, "schon")}, Hash.from_libxml("<karin zak=\"lebt\">schon</karin>"))
    assert_equal({"karin" => LibXmlNode.create({"zak"=>{}}, {}, "textmoretext")}, Hash.from_libxml("<karin>text<zak/>moretext</karin>"))
    assert_nothing_raised { Hash.from_libxml("<karin") }
    assert_nil Hash.from_libxml("<karin")
  end
end

# -*- encoding : utf-8 -*-

# USAGE: Hash.from_libxml(YOUR_XML_STRING)
require 'xml/libxml'
# adapted from 
# http://movesonrails.com/articles/2008/02/25/libxml-for-active-resource-2-0

# This class is required to represent Nodes that contain 
# attributes as well as other content, for example:
# <karin zak="lebt">schon</karin>
# We cannot non-ambigiously represent this node as a hash
# because Hashes may contain arbitrary keys.
# Having a separate class for representing such nodes
# allows for easy testing for the class (which we have
# to do anyway since hash values may be Strings, Arrays
# or other Hashes already)
# Update: No need for testing when using the iterable method.
# Usage: LibXmlNode.new("karin", "zak")

class LibXmlNode < Object
  attr_accessor :subnodes
  attr_accessor :attributes
  attr_accessor :text

  def initialize
    @subnodes = {}
    @attributes = {}
    @text = ""
  end

  def self.create(n, a, t)
    l = LibXmlNode.new
    l.subnodes = n
    l.attributes = a
    l.text = t
    l
  end

  def add_attribute(key, value)
    @attributes[key] = value
  end
    
  def add_node(key, value)
    if @subnodes[key] 
      if @subnodes[key].is_a? Object::Array
        @subnodes[key] << value
      else
        @subnodes[key] = [@subnodes[key], value]
      end
    else
      @subnodes[key] = value
    end
  end
  
  def add_text(t)
    @text << t
  end

  def simplify
    if @attributes.empty?
      if @text == ""
        return @subnodes
      end
      if @subnodes == {}
        return @text
      end
    end
    return self
  end
 
  def ==(other)
    if other.class == LibXmlNode
      if @subnodes == other.subnodes and @attributes == other.attributes and @text == other.text
        return true
      end
    end
    false
  end

  def iterable
    [self]
  end
end

class Hash 
  def iterable
    [self]
  end

  def to_libxmlnode
    LibXmlNode.create(self, {}, "")
  end

  class << self
    def from_libxml!(xml, strict=true) 
      XML.default_load_external_dtd = false
      XML.default_pedantic_parser = strict
      result = XML::Parser.string(xml).parse 
      return { result.root.name.to_s => xml_node_to_hash(result.root)} 
    end 

    def from_libxml(xml, strict=true) 
      begin
        from_libxml!(xml, strict)
      rescue Exception => e
        nil
      end
    end 

    def xml_node_to_hash(node) 
      n = LibXmlNode.new
      if node.element? 
        node.attributes.each do |attribute|
          n.add_attribute attribute.name.to_s, attribute.value
        end

        node.each_child do |child| 
          if child.text?
            if not child.children?
              n.add_text child.content.to_s.strip
            end
          else
            n.add_node child.name.to_s, xml_node_to_hash(child) 
          end
        end
      end 
      return n.simplify
    end
  end
end

class String
  def iterable
    [self]
  end

  def to_b
    self.upcase == 'TRUE' or self == '1'
  end

  def to_libxmlnode
    LibXmlNode.create({}, {}, self)
  end
end

class Array
  def iterable
    self
  end

  def to_libxmlnode
    LibXmlNode.create(self, {}, "")
  end
end

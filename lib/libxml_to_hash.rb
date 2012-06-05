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
# Usage: LibXmlNode.new("karin", "zak")

class LibXmlNode < Object
  attr_reader :subnodes
  attr_reader :attributes
  attr_reader :text

  def initialize()
    @subnodes = {}
    @attributes = {}
    @text = ""
  end

  def add_attribute(key, value)
    @attributes[key] = value
  end
    
  def add_node(key, value)
    if @subnodes[key] 
      if @subnodes[key].isa? Array
        @subnodes[key] << [value]
      else
        @subnodes[key] = [@subnodes[key], value]
      end
    else
      @subnodes[key] = value
    end
  end

  def simplify
    if @subnodes and @attributes.empty? and @text == ""
      return @subnodes
    end
    if @text != "" and not @attributes.empty? and not @subnodes
      return @text
    end
    return self
  end
      
private:
  def merge_into_hash!(the_hash, the_new_hash)
    for x in the_new_hash do
      if the_hash.has_key? x.key
        if the_hash[x.key] is_a? Array
          the_hash[x.key] << 
        
    @attributes.merge a
  end

  def add_subnode(n)
    @subnodes.merge 

  def ==(other)
    if other.class == LibXmlNode
      if @content == other.content and @attributes == other.attributes and @text == other.text
        return true
      end
    end
    false
  end
end

class Hash 
  class << self
    def from_libxml(xml, strict=true) 
      begin
        XML.default_load_external_dtd = false
        XML.default_pedantic_parser = strict
        result = XML::Parser.string(xml).parse 
        return { result.root.name.to_s => xml_node_to_hash(result.root)} 
      rescue Exception => e
#        raise # only for debugging
            # raise your custom exception here
      end
    end 

    def xml_node_to_hash(node) 
      # If we are at the root of the document, start the hash 
      n = LibXmlNode.new
      if node.element? 
        node.attributes.each do |attribute|
          n.add_attribute attribute.name.to_s, attribute.value
        end

        if node.children? 
          result_hash = {}
          node.each_child do |child| 
            result = xml_node_to_hash(child) 

#            if result.class == String
#              if !child.next? and !child.prev
#puts "child: #{child} children? #{child.children?}"
#                if (result_hash_attributes != {}) or (child.children?)
#puts "KARIN #{result} node is #{node}"
#                  return LibXmlNode.new(result, result_hash_attributes)
#                end
#puts "ZAK node is #{node}"
#                return result
#              end
            if result_hash[child.name.to_s]
              if result_hash[child.name.to_s].is_a?(Object::Array)
                result_hash[child.name.to_s] << result
              else
                result_hash[child.name.to_s] = [result_hash[child.name.to_s]] << result
              end
            else 
              result_hash[child.name.to_s] = result
            end
          end
          return LibXmlNode.new(result_hash, result_hash_attributes)
        else 
          return LibXmlNode.new({}, result_hash_attributes)
        end 
      else 
puts "content is #{node.content.to_s}"
        return node.content.to_s 
      end 
      return nil
    end
  end
end


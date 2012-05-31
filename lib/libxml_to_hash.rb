# -*- encoding : utf-8 -*-
begin

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
  attr_reader :content
  attr_reader :attributes

  def initialize(content, attributes)
    @content = content
    @attributes = attributes
  end

  def ==(other)
    @content == other.content and @attributes == other.attributes
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
      if node.element? 
        result_hash_attributes = {}
        node.attributes.each do |attribute|
          result_hash_attributes[attribute.name.to_s] = attribute.value
        end

        if node.children? 
          result_hash = {}
          node.each_child do |child| 
            result = xml_node_to_hash(child) 

            if child.name == "text"
              if !child.next? and !child.prev?
                return LibXmlNode.new(result, result_hash_attributes)
              end
            elsif result_hash[child.name.to_s]
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
        return node.content.to_s 
      end 
    end          
  end
end

rescue MissingSourceFile => e
  # no libxml => use rails default rexml
end


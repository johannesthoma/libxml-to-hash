LibXML-To-Hash
==============

The libxml-to-hash gem provides a thin layer between libxml and
the Ruby world. It exports a method Hash#from_libxml which takes
a string argument containing XML and returns a newly created
hash that contains the XML in a parsed form. 

Installation
------------

Without bundler, do:

  gem install libxml-to-hash

With bundler add 

  gem 'libxml-to-hash', :git => "https://github.com/johannesthoma/libxml-to-hash"

to Gemfile and do 

  bundle install

to install the gem.

You can omit the s in https if https should not work on your site.

Usage
-----

First, do a:

  require 'libxml-to-hash'

Then, 

  h = Hash.from_libxml("<root><node>Content</node></root>")

will return a hash:

  {"root" => {"node" => "Content"}}

which is simpler than the output from libxml itself.

The hash format
---------------

Keys are always strings.
Values might be one of the following:

* Strings (when there is only text content)
* Arrays (where there is more than one subnode like in <root><subnode>x</subnode><subnode>y</subnode></root>
* LibxmlToHash::XmlNodes if both content and attributes are given.

See the unit test file for examples.

Iterables
---------

All objects that serve as values respond to iterable, which returns
an object that repsonds to each (actually an Array). That is a for
loop for those object will always work. Suppose you have

  h = Hash.from_libxml("<root><node>Content</node></root>")

Then 

  for f in h["root"]["node"].iterable do
 
works even though there is only one node object (if there were more
than one, the value is an Array anyway). This is a convenience method
that is very handy, because there is no need to look at the class
of the value object when more than one is possible.

to_libxmlnode method
--------------------
The to_libxmlnode method is defined for Hash and String.
    
Use this if you are not sure if the object may be either a
String/Hash or LibXmlNode (both text and subnodes are given)
to convert the String/Hash to a LibXmlNode.

Why not use Hash#from_xml?
--------------------------

This uses ReXML which is (at least the version we use) about 
50 times slower than libxml.

Known bugs
----------

Currently attributes in the root node are not reported.

The xml_node_to_hash helper method shouldn't be in the Hash class.
There might be name clashes with other methods.

Authors
-------

This gem was written by Johannes Thoma <johannes.thoma@gmx.at> based
on work of Kristof Klee and a Stackoverflow posting.

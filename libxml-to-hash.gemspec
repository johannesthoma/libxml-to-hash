Gem::Specification.new do |s|
  s.name        = 'libxml-to-hash'
  s.version     = '0.2.2'
  s.date        = '2012-06-05'
  s.summary     = "A simple library to convert XML strings to hashes using libxml"
  s.description = "A simple library to convert XML strings to hashes using libxml

This adds to from_lib_xml method to the Hash class which uses libxml (which
is much faster than ReXML) to convert a XML string into a Hash"
  s.authors     = ["Johannes Thoma"]
  s.email       = 'johannes.thoma@gmx.at'
  s.files       = ["lib/libxml_to_hash.rb"]
  s.homepage    = 'http://rubygems.org/gems/libxml-to-hash'
  s.add_dependency("libxml-ruby")

  s.require_paths = %w[lib]
end

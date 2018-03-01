require 'nokogiri'

builder = Nokogiri::HTML::Builder.new do |doc|
p doc

doc.html {
  doc.head {
    doc.meta('http-equiv' => 'Content-Type', :content => 'text/html; charset=utf-8')
  }  

  doc.body(:onload => 'some_func();') {
    doc.span.bold {
      doc.text "Hello world"
    }
  }
}
end
puts builder.to_html

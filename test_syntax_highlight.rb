require 'pygments.rb'
require 'nokogiri'

code = <<-TXT
<html>
<body>
<pre><code class="ruby"># create a custom renderer that allows highlighting of code blocks
class HTMLwithAlbino &lt; Redcarpet::Render::HTML
  def block_code(code, language)
    Albino.safe_colorize(code, language)
  end
end

markdown = Redcarpet::Markdown.new(HTMLwithAlbino, :fenced_code_blocks =&gt; true)
</code>
</pre>
</body>
</html>
TXT

def create_new_node(doc, name, attributes)
  node = Nokogiri::XML::Node.new name, doc
  attributes.each do |key, value|
    node[key] = value
  end    
  node  
end


def syntax_highlighter(html)
  doc = Nokogiri::HTML(html)

  body = doc.at_css("body")
  attr = {:href => 'GitHub2.css', :rel => 'stylesheet', :type => 'text/css'}
  body.add_previous_sibling(create_new_node(doc, 'link', attr))

  attr = {:href => 'pygments.css', :rel => 'stylesheet', :type => 'text/css'}
  body.add_previous_sibling(create_new_node(doc, 'link', attr))
  #puts doc.to_html

  doc.search("//pre//code[@class]/..").each do |pre|
    #puts pre
    pre.replace Pygments.highlight(pre.text.rstrip, :lexer => 'ruby')
    #pre.replace Albino.colorize(pre.text.rstrip, pre[:lang])
  end
  doc.to_s # doc.at_css("body").inner_html.to_s
end

 syntax_highlighter(code)

hcode =  Pygments.highlight(code, :lexer => 'ruby')
puts hcode




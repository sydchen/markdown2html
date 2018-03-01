# encoding: utf-8
$:.unshift File.dirname(__FILE__)

require 'fileutils'
require 'convert'

class Generator
  attr_reader :source_dir, :output_dir
  MARKDOWN_RE = /\.(md|markdown|txt)$/

  def initialize
    @output_dir = File.join(File.dirname(__FILE__), 'output')
    @source_dir = File.join(File.dirname(__FILE__), 'source')
    FileUtils.mkdir_p(@source_dir) unless File.exist?(@source_dir)
    FileUtils.mkdir_p(@output_dir) unless File.exist?(@output_dir)
  end

  def generate
    markdown_files = Dir.entries(source_dir).grep(MARKDOWN_RE)
    markdown_files.each do |file_name|    
      output_html_name = file_name.sub(MARKDOWN_RE, '.html')
      output_file = File.join(output_dir, output_html_name)
      next unless generate?(File.join(source_dir, file_name), output_file) 

      puts "Generating \"#{file_name}\" as \"#{output_html_name}\""
      markdown = Markdown.new(File.join(source_dir, file_name))
      html_source = markdown.to_s

      # save
      File.open(output_file, 'w') do |f|
        f.write(html_source)
      end

      # copy css
      assets_dir = File.join(File.dirname(__FILE__), 'assets')
      FileUtils.cp_r(Dir.glob("#{assets_dir}/*"), output_dir)
    end
  end

  def generate?(src_file, out_file)
    !File.exists?(out_file) || File.mtime(out_file) < File.mtime(src_file)
  end
end

generater = Generator.new
generater.generate


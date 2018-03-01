markdown_dir = "#{ENV['HOME']}/Library/Application Support/Notational Data/" 
dest_dir = File.join(File.dirname(__FILE__), 'source')

markdown_files = Dir.entries(markdown_dir).grep(/\.txt/)

markdown_files.each do |file_name|
  puts "#{File.join(markdown_dir, file_name)} to #{File.join(dest_dir, file_name)}"
  File.symlink(File.join(markdown_dir, file_name), File.join(dest_dir, file_name)) 
end

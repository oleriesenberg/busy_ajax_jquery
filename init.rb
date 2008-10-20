require 'fileutils'

# Copy the files! Play nice if the file exists.
source_path = File.dirname(__FILE__)
dest_path = File.join(RAILS_ROOT, 'public')

%w(javascripts images).each{|folder|
  files = Dir[File.join(source_path, folder, '*.*')]
  files.each{|file|
    dest_file = File.join(dest_path, folder, file.split(/(\/|\\)/).last)
    dest_file_short = dest_file.gsub(RAILS_ROOT, '').gsub(/^\//, '')
    file_short = file.gsub(RAILS_ROOT, '').gsub(/^\//, '')
    if File.exist?(dest_file)
      if folder == 'javascripts' && !FileUtils.identical?(file, dest_file)
        # and if timestamp on vendor one is newer.. 
        if File.stat(file).atime > File.stat(dest_file).atime
          puts "Warning: #{file_short} is newer than #{dest_file_short} and will *not* automatically be replaced.  Please copy #{file_short} to #{dest_file_short} if you have no local changes and the plugin javascript has updated, which it appears to have.
  eg:   cp #{file_short} #{dest_file_short}"
        end
      end
    else
      puts "BusyAjax is copying #{file_short} to #{dest_file_short}"
      FileUtils.copy(file, dest_file)
    end
  }
}

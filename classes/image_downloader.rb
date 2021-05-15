class ImageDownloader

  require 'open3'

  def self.download_image(hdurl, filename)
    stdout, stderr, status = Open3.capture3("wget --output-document=./images/#{filename} #{hdurl}")
    puts "stdout: #{stdout}"
    puts "stderr: #{stderr}"
    puts "status: #{status}"
  end

end

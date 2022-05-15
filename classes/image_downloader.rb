class ImageDownloader
  def self.download_image(image_url, image_filename, image_directory)
    output_file_path = "#{image_directory}/#{image_filename}"
    # delete the file if it exists, may not be necessary
    File.delete(output_file_path) if File.exist?(output_file_path)
    unless system('wget', "--output-document=#{output_file_path}", image_url)
      # system returns:
      #   true if the command gives zero exit status
      #   false for non zero exit status
      #   nil if command execution fails
      if File.exist?(output_file_path)
        # delete the empty file that wget created
        # this happens when the image_url is malformed
        File.delete(output_file_path)
      end
      # raise(StandardError, 'NASA can\'t find today\'s image.')
      puts "NASA can't find today's image."
    end
  end
end

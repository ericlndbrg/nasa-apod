class ImageDownloader
  attr_reader :apod_data, :image_directory

  def initialize(apod_data)
    @apod_data = apod_data
    @image_directory = File.realdirpath('images')
  end

  def download_images
    self.apod_data.each do |apod_datum|
      output_file_path = "#{self.image_directory}/#{apod_datum['title']}"
      next if File.exist?(output_file_path)
      image_url = apod_datum['hdurl'] || apod_datum['url']
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
        puts "NASA can't find the image for #{apod_datum['date']}."
      end
    end
  end
end

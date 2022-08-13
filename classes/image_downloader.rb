# frozen_string_literal: true

# downloads each APOD image
class ImageDownloader
  def initialize(apod_data)
    self.apod_data = apod_data
  end

  def download_images
    # TODO: remove forward slashes from apod['title']
    path_to_images_directory = File.realdirpath('images')
    self.apod_data.each do |apod|
      output_file_path = "#{path_to_images_directory}/#{apod['title']}"

      if File.exist?(output_file_path)
        puts "#{apod['title']} has already been downloaded"
        next
      end

      image_url = apod['hdurl'] || apod['url']
      system('wget', "--output-document=#{output_file_path}", image_url)
    end
  end

  private

  attr_accessor :apod_data
end

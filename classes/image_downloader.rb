# frozen_string_literal: true

# downloads each APOD image
class ImageDownloader
  def initialize(apod_data)
    self.apod_data = apod_data
  end

  def download_images
    path_to_images_directory = File.realdirpath('images')

    apod_data.each do |apod|
      output_file_path = "#{path_to_images_directory}/#{remove_unpermitted_chars(apod['title'])}"
      next if apod['media_type'] != 'image' || File.exist?(output_file_path)
      image_url = apod['hdurl'] || apod['url']
      system('wget', "--output-document=#{output_file_path}", image_url)
    end
  end

  # def download_images
  #   # configure wget to
  #   #   download image(s) into a specific directory
  #   #   don't re-download images that have already been downloaded
  #   #   make and use a file of URLs when more than one image needs downloading
  #   # remove the videos from apod_data
  #   if apod_data.count == 1
  #     system('wget', '--directory-prefix=../images', '--no-clobber', image_url)
  #   else
  #     system('wget', '--directory-prefix=../images', '--no-clobber', "--input-file=#{apod_urls_file}")
  #   end
  # end

  private

  attr_accessor :apod_data

  def remove_unpermitted_chars(string)
    # add an array of unpermitted chars if more are discovered
    string.gsub('/', '-')
  end
end

class ImageDownloader
  def self.download_image(image_url, image_filename)
    system('wget', "--output-document=./images/#{image_filename}", image_url, exception: true)
    # rescue RuntimeError
      # happens when the image_url is wack
      # puts 'Image could not be downloaded, invalid image_url.'
      # delete the empty file that wget saved
      # system('rm', "./images/#{image_filename}")
  end
end

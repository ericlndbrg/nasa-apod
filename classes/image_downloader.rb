class ImageDownloader

  def self.download_image(hdurl, filename)
    system('wget', "--output-document=./images/#{filename}", "#{hdurl}", exception: true)
    rescue RuntimeError
      # happens when the hdurl is wack
      puts 'Image could not be downloaded, invalid hdurl.'
      # delete the empty file that wget saved
      system('rm', "./images/#{filename}")
  end

end

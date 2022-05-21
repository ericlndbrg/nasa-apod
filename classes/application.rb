require_relative 'image_downloader'
require_relative 'nasa_apod_api'
require_relative 'database'

class Application
  attr_reader :dates, :database

  def initialize(dates)
    @database = Database.new
    @dates = dates
  end

  def run
    find_or_create_apod_records
    download_images
  end

  private

  def find_or_create_apod_records
    if self.dates.count == 1
      query_result = self.database.select_by_date(self.dates)
      # I've already fetched the APOD data for dates
      return unless query_result.empty?
      # if I make it here, I need to get APOD data from NASA
      nasa_apod_api = NasaApodApi.new(self.dates)
    else
      query_result = self.database.select_by_date_range(self.dates)
      # check for dates that are missing from the results set
      date_range = (Date.parse(self.dates[0])..Date.parse(self.dates[1]))
      apod_records_i_already_have = query_result.map { |result| result['date'] }
      apod_records_i_need = date_range.to_a.map(&:to_s).difference(apod_records_i_already_have)
      # I already have all the dates
      return if apod_records_i_need.empty?
      # if I make it here, I need to get APOD data from NASA
      nasa_apod_api = NasaApodApi.new(apod_records_i_need)
    end
    # get the APOD data for the dates I need from NASA
    apod_data = nasa_apod_api.fetch_apod_data
    # insert the newly fetched data
    self.database.insert_data(apod_data)
  end

  def download_images
    undownloaded_images = self.database.select_by_undownloaded_images
    return if undownloaded_images.empty?
    image_directory = File.realdirpath('images')
    threads = []
    undownloaded_images.each do |image|
      image_url = image['hdurl'] || image['url']
      threads << Thread.new do
        ImageDownloader.download_image(image_url, image['title'], image_directory)
        self.database.mark_as_downloaded(image['date'])
      end
    end
    threads.each(&:join)
  end
end

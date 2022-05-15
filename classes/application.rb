require_relative 'image_downloader'
require_relative 'nasa_apod_api'
require_relative 'database'

class Application
  attr_reader :apod_for_dates, :database

  def initialize(dates)
    @database = Database.new
    @apod_for_dates = find_or_create(dates)
  end

  def run
    self.apod_for_dates.each do |apod_for_date|
      # apod_for_date can be either an image or a video
      # since I only care about images, check its media_type and decide what to do
      if apod_for_date['media_type'] == 'image'
        # apod_for_date is an image
        if apod_for_date['downloaded'] == 0
          # I haven't downloaded it yet, download it
          download_image(apod_for_date)
          # mark apod_for_date as having been downloaded
          # mark_as_downloaded(apod_for_date['date'])
          self.database.mark_as_downloaded(apod_for_date['date'])
        else
          # I've already downloaded it
          # raise(StandardError, "This APOD has already been downloaded.")
          puts "The APOD for #{apod_for_date['date']} has already been downloaded."
        end
      else
        # self.date's APOD is not an image
        # raise(StandardError, "This APOD is not an image.")
        puts "The APOD for #{apod_for_date['date']} is not an image."
      end
    end
  end

  private

  def find_or_create(dates)
    if dates.count == 1
      query_result = self.database.select_by_date(dates)
      # query_result will be an array of hashes
      # I've already fetched self.date's APOD data
      return query_result unless query_result.empty?
      # get the APOD data for the provided date from NASA
      apod_data = NasaApodApi.fetch_apod_data(dates)
      # apod_data will be an array of hashes
      # insert the newly fetched data
      self.database.insert_data(apod_data)
      # return the data
      self.database.select_by_date(dates)
    else
      query_result = self.database.select_by_date_range(dates)
      # query_result will be an array of hashes
      # check for dates that are missing from the results set
      dates_i_have = query_result.map { |result| result['date'] }
      dates_i_dont_have = (Date.parse(dates[0])..Date.parse(dates[1])).to_a.map(&:to_s).difference(dates_i_have)
      # I already have all the dates
      return query_result if dates_i_dont_have.empty?
      # get the APOD data for the dates in dates_i_dont_have from NASA
      apod_data = NasaApodApi.fetch_apod_data(dates_i_dont_have)
      # apod_data will be an array of hashes
      # insert the newly fetched data
      self.database.insert_data(apod_data)
      # return the data
      self.database.select_by_date_range(dates)
    end
  end

  def download_image(apod_for_date)
    image_directory = File.realdirpath('images')
    image_url = apod_for_date['hdurl'] || apod_for_date['url']
    ImageDownloader.download_image(image_url, apod_for_date['title'], image_directory)
  end
end

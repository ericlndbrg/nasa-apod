require_relative 'image_downloader'
require_relative 'nasa_apod_api'
require_relative 'database'

class Application
  attr_reader :database, :apod_for_dates

  def initialize(dates)
    @database = Database.new
    @apod_for_dates = find_or_create_apod_records(dates)
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
          self.database.mark_as_downloaded(apod_for_date['date'])
        else
          # I've already downloaded it
          puts "The APOD for #{apod_for_date['date']} has already been downloaded."
        end
      else
        # apod_for_date's APOD is not an image
        puts "The APOD for #{apod_for_date['date']} is not an image."
      end
    end
  end

  private

  def find_or_create_apod_records(dates)
    if dates.count == 1
      query_result = self.database.select_by_date(dates)
      # I've already fetched the APOD data for dates
      return query_result unless query_result.empty?
      # get the APOD data for the provided date from NASA
      apod_data = NasaApodApi.fetch_apod_data(dates)
      # insert the newly fetched data
      self.database.insert_data(apod_data)
      # return the data
      self.database.select_by_date(dates)
    else
      query_result = self.database.select_by_date_range(dates)
      # check for dates that are missing from the results set
      date_range = (Date.parse(dates[0])..Date.parse(dates[1]))
      apod_records_i_already_have = query_result.map { |result| result['date'] }
      apod_records_i_need = date_range.to_a.map(&:to_s).difference(apod_records_i_already_have)
      # I already have all the dates
      return query_result if apod_records_i_need.empty?
      # get the APOD data for the dates in apod_records_i_need from NASA
      apod_data = NasaApodApi.fetch_apod_data(apod_records_i_need)
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

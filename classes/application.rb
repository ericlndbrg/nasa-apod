require 'date'
require 'dotenv/load'
require 'net/http'
require 'json'
require_relative 'image_downloader'
require_relative 'apod_datum'

class Application
  attr_reader :today

  def initialize
    @today = Date.today.to_s
  end

  def run
    # check the db for a record with today's date
    apod_for_today = ApodDatum.find(self.today)
    # if today's apod record is found
    if !apod_for_today.nil?
      # if media_type == image
      if apod_for_today['media_type'] == 'image'
        # if image has been downloaded
        if apod_for_today['downloaded'] == 1
          raise(StandardError, 'Today\'s image has already been downloaded')
        else
          # if image has not been downloaded
          # this will happen if the image downloader fails from a previous attempt and the script is ran again before the next APOD is published
          # download today's apod image
          download_image(apod_for_today)
          # set the downloaded = true if download succeeds
          ApodDatum.update(self.today)
        end
      else
        # media_type != image
        raise(StandardError, 'Today\'s APOD is not an image.')
      end
    else
      # today's apod record was not found
      # use NASA APOD API to get today's APOD data
      apod_data = fetch_nasa_apod_data
      apod_attributes = [
        apod_data['copyright'],
        apod_data['date'],
        apod_data['explanation'],
        apod_data['hdurl'],
        apod_data['media_type'],
        apod_data['service_version'],
        apod_data['title'],
        apod_data['url']
      ]
      # save response in db
      ApodDatum.insert(apod_attributes)
      # grab the new row
      apod_for_today = ApodDatum.find(self.today)
      # if media_type == image
      if apod_for_today['media_type'] == 'image'
        # download the image
        download_image(apod_for_today)
        # set downloaded = true if download succeeds
        ApodDatum.update(self.today)
        # delete the apod if the app is in dev mode, makes development easier
        ApodDatum.destroy(self.today) if ENV['APP_ENV'] == 'dev'
      else
        # media_type != image
        raise(StandardError, 'Today\'s APOD is not an image.')
      end
    end
  rescue StandardError => e
    puts e.message
  end

  private

  def fetch_nasa_apod_data
    nasa_uri = URI("https://api.nasa.gov/planetary/apod?api_key=#{ENV['API_KEY']}")
    response = Net::HTTP.get(nasa_uri)
    api_response = JSON.parse(response)
  end

  def download_image(record)
    image_directory = File.realdirpath('images')
    image_url = record.key?('hdurl') ? record['hdurl'] : record['url']
    ImageDownloader.download_image(image_url, record['title'], image_directory)
  end
end

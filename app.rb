#!/usr/bin/env ruby

require 'dotenv/load'
require 'net/http'
require 'json'
require_relative 'classes/image_downloader'

# put the next two methods in a module
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

def main
  require 'date'
  require 'sqlite3'
  # check the db for a record with today's date
  today = Date.today.to_s
  db = SQLite3::Database.new('db/dev.db', results_as_hash: true)
  apod_for_today = db.execute("SELECT * FROM apod_details WHERE date = ?", today) # should be an empty array or have at most 1 record
  # if today's apod record is found
  if !apod_for_today.empty?
    # if media_type == image
    if apod_for_today[0]['media_type'] == 'image'
      # if image has been downloaded
      if apod_for_today[0]['downloaded'] == 1
        db.close
        raise(StandardError, 'Today\'s image has already been downloaded')
      else
        # if image has not been downloaded
        # this will happen if the image downloader fails from a previous attempt and the script is ran again before the next APOD is published
        # download today's apod image
        download_image(apod_for_today[0])
        # set the downloaded = true if download succeeds
        db.execute("UPDATE apod_details SET downloaded = 1 WHERE date = ?", today)
        db.close
      end
    else
      # media_type != image
      db.close
      raise(StandardError, 'Today\'s APOD is not an image.')
    end
  else
    # today's apod record was not found
    # use NASA APOD API to get today's APOD data
    apod_data = fetch_nasa_apod_data
    # the order of the keys in apod_data might change, explicitly specify values to account for that
    values = [apod_data['copyright'], apod_data['date'], apod_data['explanation'], apod_data['hdurl'], apod_data['media_type'], apod_data['service_version'], apod_data['title'], apod_data['url']]
    # save response in db
    db.execute("INSERT INTO apod_details(copyright, date, explanation, hdurl, media_type, service_version, title, url) VALUES(?, ?, ?, ?, ?, ?, ?, ?)", values)
    # grab the new row
    new_row = db.execute("SELECT * FROM apod_details WHERE date = ?", today)
    # if media_type == image
    if new_row[0]['media_type'] == 'image'
      # download the image
      download_image(new_row[0])
      # set downloaded = true if download succeeds
      db.execute("UPDATE apod_details SET downloaded = 1 WHERE date = ?", today)
      db.close
    else
      # media_type != image
      db.close
      raise(StandardError, 'Today\'s APOD is not an image.')
    end
  end
rescue StandardError => e
  puts e.message
end

main

require_relative 'nasa_apod_api'
require_relative 'database'

class ApodDatum < Database
  # this class is supposed to be a Rails-like model for the apod_data table
  # each instance represents a row in the apod_data table

  attr_reader :copyright, :date, :explanation, :hdurl, :media_type, :service_version, :title, :url, :downloaded

  def initialize(date)
    apod_data = find_or_create(date)

    @copyright = apod_data['copyright']
    @date = apod_data['date']
    @explanation = apod_data['explanation']
    @hdurl = apod_data['hdurl']
    @media_type = apod_data['media_type']
    @service_version = apod_data['service_version']
    @title = apod_data['title']
    @url = apod_data['url']
    @downloaded = apod_data['downloaded']
  end

  def mark_as_downloaded
    # set the downloaded attribute for self.date's APOD to 1
    execute_query('UPDATE apod_data SET downloaded = 1 WHERE date = ?', [self.date])
  end

  private

  def find_or_create(date)
    # check to see if I've already fetched self.date's APOD data
    query_result = execute_query('SELECT * FROM apod_data WHERE date = ?', [date], return_result: true).first

    # I've already fetched self.date's APOD data
    return query_result unless query_result.nil?

    # I haven't fetched self.date's APOD data yet, get it from NASA
    apod_data = NasaApodApi.fetch_apod_data(date)
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
    # save the response
    execute_query('INSERT INTO apod_data(copyright, date, explanation, hdurl, media_type, service_version, title, url) VALUES(?, ?, ?, ?, ?, ?, ?, ?)', apod_attributes)
    # grab the new data and make an instance with it
    query_result = execute_query('SELECT * FROM apod_data WHERE date = ?', [date], return_result: true).first
  end
end

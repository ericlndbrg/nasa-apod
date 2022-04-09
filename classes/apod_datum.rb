require 'sqlite3'
require_relative 'nasa_apod_api'

class ApodDatum
  # this class is supposed to be a Rails-like model for the apod_data table

  attr_accessor :copyright, :date, :explanation, :hdurl, :media_type, :service_version, :title, :url, :downloaded

  def self.find_or_create(date)
    db = SQLite3::Database.new('db/dev.db', results_as_hash: true)
    query_result = db.execute('SELECT * FROM apod_data WHERE date = ?', date).first

    if query_result.nil?
      apod_data = NasaApodApi.fetch_apod_data
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
      db.execute('INSERT INTO apod_data(copyright, date, explanation, hdurl, media_type, service_version, title, url) VALUES(?, ?, ?, ?, ?, ?, ?, ?)', apod_attributes)
      query_result = db.execute('SELECT * FROM apod_data WHERE date = ?', date).first
      db.close
      new(query_result)
    else
      db.close
      new(query_result)
    end
  end

  def initialize(apod_data)
    self.copyright = apod_data['copyright']
    self.date = apod_data['date']
    self.explanation = apod_data['explanation']
    self.hdurl = apod_data['hdurl']
    self.media_type = apod_data['media_type']
    self.service_version = apod_data['service_version']
    self.title = apod_data['title']
    self.url = apod_data['url']
    self.downloaded = apod_data['downloaded']
  end

  def update
    db = SQLite3::Database.new('db/dev.db')
    db.execute('UPDATE apod_data SET downloaded = 1 WHERE date = ?', self.date)
    db.close
  end
end

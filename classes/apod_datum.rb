require 'sqlite3'

class ApodDatum
  # this class is supposed to be a Rails-like model for the apod_data table

  attr_reader :query_result

  def find(date)
    # self.query_result should be either
    #   an empty array or
    #   an array with today's APOD a hash in the first index position
    execute_query('SELECT * FROM apod_data WHERE date = ?', date)
    self.query_result.first
  end

  def update(date)
    execute_query('UPDATE apod_data SET downloaded = 1 WHERE date = ?', date)
  end

  def insert(attributes)
    execute_query('INSERT INTO apod_data(copyright, date, explanation, hdurl, media_type, service_version, title, url) VALUES(?, ?, ?, ?, ?, ?, ?, ?)', attributes)
  end

  def destroy(date)
    execute_query('DELETE FROM apod_data WHERE date = ?', date)
  end

  private

  def execute_query(sql, data)
    db = SQLite3::Database.new('db/dev.db', results_as_hash: true)
    @query_result = db.execute(sql, data)
    db.close
  end
end

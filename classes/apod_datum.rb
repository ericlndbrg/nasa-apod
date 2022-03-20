class ApodDatum
  # this class is supposed to be a Rails-like model for the apod_data table
  require 'sqlite3'

  def self.find(date)
    db = SQLite3::Database.new('db/dev.db', results_as_hash: true)
    # apod_for_today should be an empty array or have at most 1 record
    apod_for_today = db.execute("SELECT * FROM apod_data WHERE date = ?", date)
    db.close
    apod_for_today
  end

  def self.update(date)
    db = SQLite3::Database.new('db/dev.db')
    db.execute("UPDATE apod_data SET downloaded = 1 WHERE date = ?", date)
    db.close
  end

  def self.insert(values)
    db = SQLite3::Database.new('db/dev.db')
    db.execute("INSERT INTO apod_data(copyright, date, explanation, hdurl, media_type, service_version, title, url) VALUES(?, ?, ?, ?, ?, ?, ?, ?)", values)
    db.close
  end

  def self.destroy(date)
    db = SQLite3::Database.new('db/dev.db')
    db.execute("DELETE FROM apod_data WHERE date = ?", date)
    db.close
  end
end

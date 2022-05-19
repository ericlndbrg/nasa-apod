require 'sqlite3'

class Database
  attr_reader :path_to_db_file

  def initialize
    @path_to_db_file = File.absolute_path(File.join('db', "#{ENV['APP_ENV']}.db"))
  end

  def select_by_date(date)
    execute_query(return_result: true) do |db|
      db.execute('SELECT * FROM apod_data WHERE date = ?', date)
    end
  end

  def select_by_date_range(dates)
    execute_query(return_result: true) do |db|
      db.execute('SELECT * FROM apod_data WHERE date BETWEEN ? AND ?', dates)
    end
  end

  def select_by_undownloaded_images
    execute_query(return_result: true) do |db|
      db.execute('SELECT date, hdurl, url, title FROM apod_data WHERE media_type = ? AND downloaded = ?', ['image', 0])
    end
  end

  def insert_data(apod_data)
    apod_data.each do |apod_datum|
      apod_attributes = [
        apod_datum['copyright'],
        apod_datum['date'],
        apod_datum['explanation'],
        apod_datum['hdurl'],
        apod_datum['media_type'],
        apod_datum['service_version'],
        apod_datum['title'],
        apod_datum['url']
      ]
      execute_query do |db|
        db.execute('INSERT INTO apod_data(copyright, date, explanation, hdurl, media_type, service_version, title, url) VALUES(?, ?, ?, ?, ?, ?, ?, ?)', apod_attributes)
      end
    end
  end

  def mark_as_downloaded(date)
    execute_query do |db|
      db.execute('UPDATE apod_data SET downloaded = 1 WHERE date = ?', [date])
    end
  end

  private

  def execute_query(return_result: false)
    db = SQLite3::Database.new(self.path_to_db_file, results_as_hash: true)
    result = yield(db)
    db.close
    return result if return_result
  end
end

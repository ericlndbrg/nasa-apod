require 'sqlite3'

class Database
  def select_by_date(date)
    execute_query(return_result: true) { |db| db.execute('SELECT * FROM apod_data WHERE date = ?', date) }
  end

  def select_by_date_range(dates)
    execute_query(return_result: true) { |db| db.execute('SELECT * FROM apod_data WHERE date BETWEEN ? AND ?', dates) }
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
      execute_query { |db| db.execute('INSERT INTO apod_data(copyright, date, explanation, hdurl, media_type, service_version, title, url) VALUES(?, ?, ?, ?, ?, ?, ?, ?)', apod_attributes) }
    end
  end

  def mark_as_downloaded(date)
    execute_query { |db| db.execute('UPDATE apod_data SET downloaded = 1 WHERE date = ?', [date]) }
  end

  private

  def execute_query(return_result: false)
    path_to_db_file = File.absolute_path(File.join('db', "#{ENV['APP_ENV']}.db"))
    db = SQLite3::Database.new(path_to_db_file, results_as_hash: true)
    result = yield(db)
    db.close
    return result if return_result
  end
end

require 'sqlite3'

class Database
  def execute_query(query, data, return_result: false)
    path_to_db_file = File.absolute_path(File.join('db', "#{ENV['APP_ENV']}.db"))
    db = SQLite3::Database.new(path_to_db_file, results_as_hash: true)
    result = db.execute(query, data)
    db.close
    return result if return_result
  end
end

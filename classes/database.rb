require 'sqlite3'

class Database
  def self.execute_query(query, data, return_result: false)
    db = SQLite3::Database.new('db/dev.db', results_as_hash: true)
    result = db.execute(query, data)
    db.close
    return result if return_result
  end
end

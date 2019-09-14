require 'pg'

class Database
  def initialize(pg_conn, queries)
    @pg_conn  = pg_conn
    @queries = queries
  end

  def self.connect(db_url, queries)
    pg_conn = PG::Connection.new(db_url)
    new(pg_conn, queries)
  end

  # def exec_sql(sql)
  #   @pg_conn.exec(sql).to_a
  # end

  # def method_missing(name, *args)
  #   sql = @queries.fetch(name) % args
  #   exec_sql(sql)
  # end

  def method_missing(name, *args)
    sql = @queries.fetch(name)
    @pg_conn.exec_params(sql, args).to_a.map do |row|
      Record.new(row)
    end
  end
end

class Record
  def initialize(row)
    @row = row
  end

  def method_missing(col_name)
    @row.fetch(col_name.to_s)
  end
end

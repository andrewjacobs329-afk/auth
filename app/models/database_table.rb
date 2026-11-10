# One table in the database, read straight from SQLite for the Data page: its columns and its
# rows. It reads the table itself rather than a model, so a table shows up as soon as its
# migration has run, model or no model.
class DatabaseTable
  MAX_ROWS = 200
  # Tables Rails keeps for itself
  HIDDEN = ["schema_migrations", "ar_internal_metadata"]

  attr_reader :name

  def self.all
    (connection.tables - HIDDEN).sort.map { |name| new(name) }
  end

  def self.connection
    ActiveRecord::Base.connection
  end

  def initialize(name)
    @name = name
  end

  def columns
    @columns ||= connection.columns(name).map(&:name)
  end

  def count
    @count ||= connection.select_value("SELECT COUNT(*) FROM #{quoted_name}")
  end

  def cut?
    count > MAX_ROWS
  end

  # The newest MAX_ROWS rows, oldest first, so a row just added is at the bottom.
  def rows
    order = connection.quote_column_name(connection.primary_key(name) || "rowid")
    newest = "SELECT * FROM #{quoted_name} ORDER BY #{order} DESC LIMIT #{MAX_ROWS}"
    connection.select_all("SELECT * FROM (#{newest}) ORDER BY #{order}").rows
  end

  private

  def connection
    self.class.connection
  end

  def quoted_name
    connection.quote_table_name(name)
  end
end

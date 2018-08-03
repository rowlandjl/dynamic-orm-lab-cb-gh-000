require_relative "../config/environment.rb"
require 'active_support/inflector'

class InteractiveRecord

  def initialize(options = {})
    options.each { |property, value| self.send("#{property}=", value)}
  end

  def save
    sql = <<-SQL
    INSERT INTO #{table_name_for_insert} (#{col_names_for_insert})
    VALUES (#{values_for_insert})
    SQL
    DB[:conn].execute(sql)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM #{table_name_for_insert}")[0][0]
  end

  def table_name_for_insert
    self.class.table_name
  end

  def col_names_for_insert
    self.class.column_names.delete_if { |col| col == 'id'}.join(', ')
  end

  def values_for_insert
    values = []
    self.class.column_names.each do |col|
      values << "'#{send(col)}'" unless send(col).nil?
    end
    values.join(', ')
  end 

  def self.table_name
    self.to_s.downcase.pluralize 
  end 
end

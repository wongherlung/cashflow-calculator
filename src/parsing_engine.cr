require "yaml"
require "csv"
require "./models/statement.cr"
require "./models/transaction.cr"

class ParsingEngine
  def initialize
    @transactions = Array(Transaction).new
    @statements = Array(Statement).new
    Dir["../accounts/*.yml"].each do |yaml_file|
      @statements.push(Statement.new(File.read(yaml_file)))
    end
  end

  def parse
    Dir["../input/*.csv"].each do |csv_file|
      csv_string = File.read(csv_file)
      s = get_statement_template(csv_file, csv_string)

      # Ignore if bank can't be determined for any CSV
      if s.nil?
        STDERR.puts "Unable to determine bank for #{csv_file.split("/").last}"
        next
      end

      csv_arr = CSV.parse(csv_string)
      puts csv_arr[s.transaction_start_row-1...csv_arr.size]
    end
  end

  private def get_statement_template(filename : String, csv_string : String) : (Statement | Nil)
    @statements.each do |s|
      return s if s.matches(filename, csv_string)
    end
  end
end

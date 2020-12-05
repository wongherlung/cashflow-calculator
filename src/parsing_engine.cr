require "yaml"
require "csv"
require "./category_engine"
require "./models/statement.cr"
require "./models/transaction.cr"

class ParsingEngine
  def initialize
    @category_engine = CategoryEngine.new
    @transactions = Array(Transaction).new
    @statements = Array(Statement).new
    Dir["../accounts/*.yml"].each do |yaml_file|
      @statements.push(Statement.new(File.read(yaml_file)))
    end
  end

  def parse : Array(Transaction)
    Dir["../input/*.csv"].each do |csv_file|
      csv_string = File.read(csv_file)
      s = get_statement_template(csv_file, csv_string)

      # Ignore if bank can't be determined for any CSV
      if s.nil?
        STDERR.puts "Unable to determine bank for #{csv_file.split("/").last}"
        next
      end

      # Remove BOM character if it exists
      # See: https://stackoverflow.com/questions/33592432/mysterious-leading-empty-character-at-beginning-of-a-string-which-came-from-cs
      csv_string = csv_string[1..] if csv_string.codepoints.includes?(65279)

      csv_arr = CSV.parse(csv_string)
      # Only process from this row onwards
      csv_arr = csv_arr[s.transaction_start_row..csv_arr.size-1]
      # Remove empty rows
      csv_arr.reject! { |x| x.empty? }

      i = 0
      until i >= csv_arr.size
        value = date = category = description = bank = ""
        transaction_type = TransactionType::Outflow

        # Account for multiple rows per transaction
        (i...i+s.num_rows_per_transaction).each do |j|
          # Special case when subsequent row is the next transaction
          if j != i && !csv_arr[j][s.date_column].empty?
            i -= s.num_rows_per_transaction - 1
            break
          end

          # Extract transaction information out
          date = csv_arr[j][s.date_column] unless csv_arr[j][s.date_column].empty?
          s.description_columns.each do |k|
            description += csv_arr[j][k] + " " unless csv_arr[j][k].empty?
          end
          if i == j
            value = csv_arr[j][s.outflow_column] unless csv_arr[j][s.outflow_column].gsub(" ", "").empty?
            value = csv_arr[j][s.inflow_column] unless csv_arr[j][s.inflow_column].gsub(" ", "").empty?
            transaction_type = TransactionType::Inflow if csv_arr[j][s.outflow_column].gsub(" ", "").empty?
          end
        end

        # Remove BOM character if it exists
        # See: https://stackoverflow.com/questions/33592432/mysterious-leading-empty-character-at-beginning-of-a-string-which-came-from-cs
        date = date[1..] if date.codepoints.includes?(65279)

        category_info = @category_engine.find_category_for(description)
        @transactions.push(Transaction.new(
          transaction_type,
          value.gsub(",", "").to_f32.abs,
          Time.parse(date, s.date_format, Time::Location::UTC),
          category_info.nil? ? "Others" : category_info[:category].name,
          description,
          s.name
        ))
        i += s.num_rows_per_transaction
      end
    end

    # Filter out ignored transactions
    @transactions.reject! { |x| x.category == "Ignored" }
    return @transactions
  end

  private def get_statement_template(filename : String, csv_string : String) : (Statement | Nil)
    @statements.each do |s|
      return s if s.matches(filename, csv_string)
    end
  end
end

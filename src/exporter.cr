class Exporter
  def initialize(@calculation_engine : CalculationEngine)
  end

  def export_csv_report(output_file : String, show_descriptions : Bool)
    rows = File.read_lines(output_file).clone()
    description_rows = rows.clone()
    rows = rows.map { |i| replace_with_total(i, show_descriptions) }

    rows.push("\"#{@calculation_engine.transactions_above(TransactionType::Outflow, 100.00).map { |t| t.description + " - $" + t.value.to_s }.join("\n")}\"")
    File.write("./output.csv", rows.join("\n")) unless show_descriptions
    File.write("./output.csv", rows.join("\n") + get_descriptions(description_rows).join("\n")) if show_descriptions
  end

  private def replace_with_total(row : String, show_descriptions : Bool) : String
    matches = row.scan(/<[^,]*>/)
    return row if matches.empty?

    matches.each do |m|
      key = m[0].match(/[^>^<]+/).not_nil![0]
      transaction_type = nil
      if key.split(":").size > 1
        transaction_type = TransactionType::Outflow if key.split(":").last == "outflow"
        transaction_type = TransactionType::Inflow if key.split(":").last == "inflow"
        key = key.split(":").first
      end
      row = row.gsub(m[0], @calculation_engine.total(transaction_type, key))
    end
    return row
  end

  private def get_descriptions(rows : Array(String)) : Array(String)
    descriptions = [] of String

    rows.each do |row|
      matches = row.scan(/<[^,]*>/)
      next if matches.empty?

      matches.each do |m|
        key = m[0].match(/[^>^<]+/).not_nil![0]
        key = key.split(":").first

        descriptions.push(@calculation_engine.get_descriptions_for_transactions(key))
      end
    end

    
    return descriptions
  end
end

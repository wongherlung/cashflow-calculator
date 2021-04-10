class Exporter
  def initialize(@calculation_engine : CalculationEngine)
  end

  def export_csv_report(output_file : String)
    rows = File.read_lines(output_file).clone()
    description_rows = rows.clone()
    rows = rows.map { |i| replace_value(i) }

    rows.push("\"#{@calculation_engine.transactions_above(TransactionType::Outflow, 100.00).map { |t| t.description + " - $" + t.value.to_s }.join("\n")}\"")
    File.write("./output.csv", rows.join("\n"))
  end

  private def replace_value(row : String) : String
    matches = row.scan(/<[^,]*>/)
    return row if matches.empty?

    matches.each do |m|
      key = m[0].match(/[^>^<]+/).not_nil![0]
      transaction_type = nil
      show_description = false
      outstanding = false
      if key.split(":").size > 1
        transaction_type = TransactionType::Outflow if key.split(":").last == "outflow"
        transaction_type = TransactionType::Inflow if key.split(":").last == "inflow"
        show_description = key.split(":").last == "description"
        outstanding = key.split(":").last == "outstanding"
        key = key.split(":").first
      end
      row = row.gsub(m[0], @calculation_engine.total(transaction_type, key)) unless transaction_type.nil?
      row = row.gsub(m[0], "\"#{@calculation_engine.get_descriptions_for_transactions(key)}\"") if show_description
      row = row.gsub(m[0], "\"#{@calculation_engine.transactions_above(TransactionType::Outflow, 100.00).map { |t| t.description + " - $" + t.value.to_s }.join("\n")}\"") if outstanding
    end
    return row
  end
end

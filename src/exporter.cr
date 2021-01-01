class Exporter
  def initialize(@calculation_engine : CalculationEngine)
  end

  def export_csv_report(output_file : String, show_descriptions : Bool)
    rows = File.read_lines(output_file)
    rows = rows.map { |i| replace_with_total(i, show_descriptions) }
    File.write("./output.csv", rows.join("\n"))

    # p @calculation_engine.transactions_above(TransactionType::Outflow, 100.00)
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
      descriptions = @calculation_engine.get_descriptions_for_transactions(key) if show_descriptions
      row = row.gsub(m[0], "#{@calculation_engine.total(transaction_type, key)},\"#{descriptions}\"") if show_descriptions
      row = row.gsub(m[0], @calculation_engine.total(transaction_type, key)) unless show_descriptions
    end
    return row
  end
end

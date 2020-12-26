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
      key = m[0].match(/[^>^<]+/).not_nil!
      descriptions = @calculation_engine.get_descriptions_for_transactions(key[0]) if show_descriptions
      row = row.gsub(m[0], "#{@calculation_engine.total(nil, key[0])},\"#{descriptions}\"") if show_descriptions
      row = row.gsub(m[0], @calculation_engine.total(nil, key[0])) unless show_descriptions
    end
    return row
  end
end

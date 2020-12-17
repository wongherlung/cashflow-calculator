require "./importer"
require "./exporter"
require "./parsing_engine"
require "./calculation_engine"
require "./models/transaction"

def main
  importer = Importer.new
  importer.import

  puts("Parsing #{importer.csv_files.size} CSV files.")
  puts("Parsing #{importer.account_files.size} account YAML files.")
  puts("Parsing #{importer.category_files.size} category YAML files.")
  parsing_engine = ParsingEngine.new(importer.csv_files,
                                     importer.account_files,
                                     importer.category_files)
  transactions = parsing_engine.parse

  puts("Calculating expenses.")
  calculation_engine = CalculationEngine.new(transactions)
  calculation_engine.display_summary(TransactionType::Inflow)
  calculation_engine.display_summary(TransactionType::Outflow)

  exporter = Exporter.new(calculation_engine)
  # Output template file detected, will proceed to create CSV file based
  # on that template
  if importer.has_output_file
    exporter.export_csv_report(importer.output_file)
  end

end

main

require "./importer"
require "./parsing_engine"
require "./calculation_engine"
require "./models/transaction"

def main
  importer = Importer.new
  importer.import

  parsing_engine = ParsingEngine.new(importer.csv_files)
  transactions = parsing_engine.parse

  calculation_engine = CalculationEngine.new(transactions)
  puts calculation_engine.total(TransactionType::Inflow)
end

main

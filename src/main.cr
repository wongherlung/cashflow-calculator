require "./importer"
require "./parsing_engine"
require "./calculation_engine"
require "./models/transaction"

def main
  importer = Importer.new
  importer.import

  parsing_engine = ParsingEngine.new(importer.csv_files,
                                     importer.account_files,
                                     importer.category_files)
  transactions = parsing_engine.parse

  calculation_engine = CalculationEngine.new(transactions)
  calculation_engine.display_summary(TransactionType::Inflow)
  calculation_engine.display_summary(TransactionType::Outflow)
end

main

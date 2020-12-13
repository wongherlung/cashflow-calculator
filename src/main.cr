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
  transactions.each do |d|
    puts d
  end

  calculation_engine = CalculationEngine.new(transactions)
  puts calculation_engine.total(TransactionType::Outflow, "atm_withdrawal")
end

main

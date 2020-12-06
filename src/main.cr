require "./parsing_engine"
require "./calculation_engine"
require "./models/transaction"

def main
  parsing_engine = ParsingEngine.new
  transactions = parsing_engine.parse

  calculation_engine = CalculationEngine.new(transactions)
  puts calculation_engine.total(TransactionType::Inflow)
end

main

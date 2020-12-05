require "./parsing_engine"
require "./models/transaction.cr"

def main
  parsing_engine = ParsingEngine.new
  transactions = parsing_engine.parse
  inflow_transactions = transactions.select { |x| x.type == TransactionType::Inflow }
  outflow_transactions = transactions.select { |x| x.type == TransactionType::Outflow }

  total_inflow = inflow_transactions.map { |x| x.value }.reduce { |sum, i| sum + i }
  total_outflow = outflow_transactions.map { |x| x.value }.reduce { |sum, i| sum + i }
  puts total_inflow
  puts total_outflow
end

main

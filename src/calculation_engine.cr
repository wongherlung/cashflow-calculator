require "./models/transaction"

class CalculationEngine
  def initialize(@transactions : Array(Transaction))
  end

  def total(transaction_type : TransactionType, category_key : String) : Float32
    return @transactions.select { |t| t.type == transaction_type }
      .select { |t| t.category[:key] == category_key }
      .map { |t| t.value }
      .reduce { |sum, i| sum + i }
  rescue
    STDERR.puts("[Error] Unable to find transactions with transaction type \"#{transaction_type.to_s}\" and category key \"#{category_key}\"")
    exit
  end
end

require "./models/transaction.cr"

class CalculationEngine
  def initialize(@transactions : Array(Transaction))
  end

  def total(transaction_type : TransactionType) : Float32
    return @transactions.select { |t| t.type == transaction_type }
      .map { |t| t.value }
      .reduce { |sum, i| sum + i }
  end
end

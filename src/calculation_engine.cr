require "./models/transaction"

class CalculationEngine
  def initialize(@transactions : Array(Transaction))
  end

  # Displays all categories belonging to a TransasctionType
  def display_summary(transaction_type : TransactionType)
    transactions = @transactions.select { |t| t.type == transaction_type }
    categories = transactions.map { |t| t.category }.uniq
    puts "\n=== #{transaction_type.to_s} Summary ==="
    categories.each do |d|
      puts "#{d[:name]}: $#{total(transaction_type, d[:key])}" unless d[:key] == "ignore"
    end
  end

  def total(transaction_type : TransactionType | Nil, category_key : String) : Float32
    return @transactions.select { |t| transaction_type.nil? ? true : t.type == transaction_type }
      .select { |t| t.category[:key] == category_key }
      .map { |t| t.value }
      .reduce { |sum, i| sum + i }
      .round(2)
  rescue
    puts("[Warning] Did not manage to find total for transactions with type \"#{transaction_type.to_s}\" and category key \"#{category_key}\"")
    return 0.0.to_f32
  end

  def get_descriptions_for_transactions(category_key : String) : String
    return @transactions.select { |t| t.category[:key] == category_key }
      .reduce("") { |str, i| str + "#{i.description} - #{i.value}\n" }
  end

  def transactions_above(transaction_type : TransactionType | Nil, amount : Float32) : Array(Transaction)
    return @transactions.reject { |t| t.category["key"] == "ignore" }
      .select { |t| transaction_type.nil? ? true : t.type == transaction_type }
      .select { |t| t.value >= amount }
  end
end

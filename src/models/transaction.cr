enum TransactionType
  Outflow
  Inflow
end

struct Transaction
  property type, value, date, category, description, bank

  def initialize(@type : TransactionType, @value : Float32,
    @date : Time, @category : String, @description : String,
    @bank : Bank)
  end
end

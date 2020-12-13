require "./category"

enum TransactionType
  Outflow
  Inflow
end

struct Transaction
  property type, value, date, category, description, account

  def initialize(@type : TransactionType, @value : Float32,
    @date : Time, @category : NamedTuple(key: String, name: String), @description : String,
    @account : String)
  end
end

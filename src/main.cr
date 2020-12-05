require "./category_engine"
require "./parsing_engine"
require "./models/transaction.cr"

def main
  # category_engine = CategoryEngine.new
  # puts category_engine.find_category_for("adsfsdfs").nil?
  parsing_engine = ParsingEngine.new
  parsing_engine.parse
end

main

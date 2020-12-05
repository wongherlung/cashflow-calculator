require "./parsing_engine"
require "./models/transaction.cr"

def main
  parsing_engine = ParsingEngine.new
  parsing_engine.parse
end

main

require "yaml"

struct Statement
  property key, name, description, filename_regex, content_regex,
    transaction_start_row, num_rows_per_transaction,
    inflow_column, outflow_column, description_columns
    @key : String
    @name : String
    @description : String
    @filename_regex : String
    @content_regex : Array(String)
    @transaction_start_row : Int32
    @num_rows_per_transaction : Int32
    @inflow_column : Int32
    @outflow_column : Int32
    @description_columns : Array(Int32)

  def initialize(template : String)
    obj = YAML.parse(template)
    @key = obj["key"].as_s
    @name = obj["name"].as_s
    @description = obj["description"].as_s
    @filename_regex = obj["filename_regex"].as_s
    @content_regex = obj["content_regex"].as_a.map { |x| x.as_s }
    @transaction_start_row = obj["transaction_start_row"].as_i
    @num_rows_per_transaction = obj["num_rows_per_transaction"].as_i
    @inflow_column = obj["inflow_column"].as_i
    @outflow_column = obj["outflow_column"].as_i
    @description_columns = obj["description_columns"].as_a.map { |x| x.as_i }
  end

  def matches(filename : String, content : String) : Bool
    return false if filename.match(Regex.new(@filename_regex)).nil?
    @content_regex.each do |r|
      return false if content.match(Regex.new(r)).nil?
    end
    return true
  end
end

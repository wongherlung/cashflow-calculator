require "yaml"

struct Category
  property key, name, priority, regex
  @key : String
  @name : String
  @priority : Int32
  @regex : Array(String)

  def initialize(yaml_text : String)
    obj = YAML.parse(yaml_text)
    @key = obj["key"].as_s
    @name = obj["name"].as_s
    @priority = obj["priority"].as_i
    @regex = obj["regex"].as_a.map { |x| x.to_s }
  end
end

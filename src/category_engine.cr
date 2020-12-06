require "./models/category.cr"

class CategoryEngine
  def initialize
    @categories = Array(Category).new
    keys = Set(String).new
    Dir["../categories/*.yml"].each do |yaml_file|
      category = Category.new(File.read(yaml_file))

      # Check if category key is unique or not.
      if keys.includes?(category.key)
        STDERR.puts("Duplicate key for #{category.key} found.")
        exit
      end

      keys.add(category.key)
      @categories.push(category)
    end
    @categories.sort_by! { |x| x.priority }
  end

  def find_category_for(description : String) : (NamedTuple(category: Category, matched_regex: String) | Nil)
    @categories.each do |c|
      c.regex.each do |regex|
        return {category: c, matched_regex: regex} if description.match(Regex.new(regex, Regex::Options::IGNORE_CASE), 0)
      end
    end
  end
end

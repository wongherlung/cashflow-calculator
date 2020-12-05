require "./models/category.cr"

class CategoryEngine
  def initialize
    @categories = Array(Category).new
    Dir["../categories/*.yml"].each do |yaml_file|
      @categories.push(Category.new(File.read(yaml_file)))
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

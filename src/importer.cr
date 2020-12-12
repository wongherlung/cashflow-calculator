HOME_DIR_NAME = ".cashflow-calculator"

class Importer
  property csv_files, account_files, category_files

  def initialize
    @csv_files = Array(String).new
    @account_files = Array(String).new
    @category_files = Array(String).new
  end

  def import
    validate

    # Create local folder if already does not exist
    home_path = File.expand_path("~/", home: true)
    unless Dir.exists?("#{home_path}/#{HOME_DIR_NAME}")
      Dir.mkdir("#{home_path}/#{HOME_DIR_NAME}")
      Dir.mkdir("#{home_path}/#{HOME_DIR_NAME}/categories")
      Dir.mkdir("#{home_path}/#{HOME_DIR_NAME}/accounts")
    end

    @csv_files = if ARGV.size == 1
                   Dir["#{ARGV[0]}/*.csv"]
                 else
                   ["./"]
                 end

    @categories_files = Dir["#{home_path}/#{HOME_DIR_NAME}/categories/*.yml"]
    @account_files = Dir["#{home_path}/#{HOME_DIR_NAME}/accounts/*.yml"]
  end

  private def validate
    if ARGV.size == 1
      # Checks if provided directory exists or not
      unless Dir.exists?(ARGV[0])
        STDERR.puts("[Error] The provided directory does not exist.")
        exit
      end

      # Checks if there are any CSV files found in the provided directory
      if Dir["#{ARGV[0]}/*.csv"].empty?
        STDERR.puts("[Error] Unable to find any CSV files in provided directory")
        exit
      end
    end

    if ARGV.empty?
      # If no path was provided, check if current directory has CSV files
      if Dir["./*.csv"].empty?
        STDERR.puts("[Error] No CSV files found in current directory.")
        exit
      end
    end
  end
end

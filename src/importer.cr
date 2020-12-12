HOME_DIR_NAME = ".cashflow-calculator"

class Importer
  property csv_files, account_files, category_files

  def initialize
    @csv_files = Array(String).new
    @account_files = Array(String).new
    @category_files = Array(String).new
    @home_path = File.expand_path("~/", home: true)
  end

  def import
    # Create local folder if already does not exist
    unless Dir.exists?("#{@home_path}/#{HOME_DIR_NAME}")
      Dir.mkdir("#{@home_path}/#{HOME_DIR_NAME}")
      Dir.mkdir("#{@home_path}/#{HOME_DIR_NAME}/categories")
      Dir.mkdir("#{@home_path}/#{HOME_DIR_NAME}/accounts")
    end

    validate

    @csv_files = if ARGV.size == 1
                   Dir["#{ARGV[0]}/*.csv"]
                 else
                   ["./"]
                 end

    @category_files = Dir["#{@home_path}/#{HOME_DIR_NAME}/categories/*.yml"]
    @account_files = Dir["#{@home_path}/#{HOME_DIR_NAME}/accounts/*.yml"]
  end

  private def validate
    if ARGV.size == 1
      # Checks if provided directory exists or not
      unless Dir.exists?(ARGV[0])
        STDERR.puts("[Error] The provided directory does not exist.")
        exit 1
      end

      # Checks if there are any CSV files found in the provided directory
      if Dir["#{ARGV[0]}/*.csv"].empty?
        STDERR.puts("[Error] Unable to find any CSV files in provided directory")
        exit 1
      end
    end

    if ARGV.empty?
      # If no path was provided, check if current directory has CSV files
      if Dir["./*.csv"].empty?
        STDERR.puts("[Error] No CSV files found in current directory.")
        exit 1
      end
    end

    # Check that there are .yml files in the accounts folder
    if Dir["#{@home_path}/#{HOME_DIR_NAME}/accounts/*.yml"].empty?
      STDERR.puts("[Error] No account files found in #{@home_path}#{HOME_DIR_NAME}/accounts")
      exit 1
    end
  end
end

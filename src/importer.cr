class Importer
  property csv_files

  def initialize
    @csv_files = Array(String).new
  end

  def import
    validate

    @csv_files = if ARGV.size == 1
                   Dir["#{ARGV[0]}/*.csv"]
                 else
                   ["./"]
                 end
  end

  private def validate
    if ARGV.size == 1
      # Checks if provided direcotry exists or not
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
      if Dir["./*.csv"].empty?
        STDERR.puts("[Error] No CSV files found in current directory.")
        exit
      end
    end
  end
end

#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/csv_handler'

class CommandLineInterface
  attr_reader :input_file, :is_temp_file

  def initialize
    @is_temp_file = false
  end

  def parse_arguments
    @input_file = if ARGV.any?
                    input_arg = ARGV.shift
                    return display_help if input_arg == '--help'
                    input_arg
                  elsif (stdin_content = $stdin.read)
                    @is_temp_file = true
                    File.write('tempfile.csv', stdin_content)
                    'tempfile.csv'
                  end
  end

  def execute
    CsvHandler.new(input_file).execute if input_file
  ensure
    cleanup_tempfile if is_temp_file && File.exist?(input_file)
  end

  def display_help
    puts <<~HELP
      Usage:
        ./cli < input.csv    # Processes input.csv from STDIN and displays output to STDOUT

        ./cli input.csv > output.csv    # Processes input.csv and writes output to output.csv

        ./cli --help    # Shows this help message
    HELP
  end

  private

  def cleanup_tempfile
    File.delete(input_file)
  end
end

CommandLineInterface.new.tap do |cli_instance|
  cli_instance.parse_arguments
  puts cli_instance.execute
end
